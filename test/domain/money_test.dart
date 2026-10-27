import 'package:flutter_test/flutter_test.dart';
import 'package:sahel_ledger/core/money/money.dart';

void main() {
  group('parsePoisha', () {
    int ok(String s) {
      final r = parsePoisha(s);
      expect(r.isOk, isTrue, reason: 'expected "$s" to parse, got ${r.error}');
      return r.poisha!;
    }

    test('whole and decimal taka become integer poisha', () {
      expect(ok('1'), 100);
      expect(ok('1234'), 123400);
      expect(ok('1234.5'), 123450);
      expect(ok('1234.05'), 123405);
      expect(ok('.75'), 75);
      expect(ok('0.01'), 1);
      expect(ok('10.'), 1000);
    });

    test('accepts grouping, symbol and Bengali digits', () {
      expect(ok('1,23,456.78'), 12345678);
      expect(ok('৳ 50,000'), 5000000);
      expect(ok('১২৩৪.৫০'), 123450);
      expect(ok('৳১০,০০০'), 1000000);
      expect(ok('  2 000 '), 200000);
    });

    test('never rounds: more than two decimals is rejected', () {
      expect(parsePoisha('1.005').error, MoneyParseError.tooManyDecimals);
      expect(parsePoisha('0.333').error, MoneyParseError.tooManyDecimals);
    });

    test('classic float pitfalls are exact', () {
      // 0.1 + 0.2 != 0.3 in floating point; in poisha it is exact.
      expect(ok('0.1') + ok('0.2'), ok('0.3'));
      expect(ok('19.99') * 3, 5997);
      expect(ok('1.15'), 115); // 1.15 * 100 = 114.99999999999999 as double
    });

    test('rejects invalid input', () {
      expect(parsePoisha('').error, MoneyParseError.empty);
      expect(parsePoisha('abc').error, MoneyParseError.invalid);
      expect(parsePoisha('-5').error, MoneyParseError.negative);
      expect(parsePoisha('1.2.3').error, MoneyParseError.invalid);
      expect(parsePoisha('0').error, MoneyParseError.invalid);
      expect(parsePoisha('0', allowZero: true).poisha, 0);
      expect(parsePoisha('99999999999999999').error, MoneyParseError.tooLarge);
    });
  });

  group('formatPoisha', () {
    test('South Asian grouping', () {
      expect(formatPoisha(12345678), '৳ 1,23,456.78');
      expect(formatPoisha(100), '৳ 1.00');
      expect(formatPoisha(5), '৳ 0.05');
      expect(formatPoisha(1234567890123), '৳ 12,34,56,78,901.23');
      expect(formatPoisha(-250000), '-৳ 2,500.00');
      expect(formatPoisha(250000, signed: true), '+৳ 2,500.00');
      expect(formatPoisha(5000000, compactDecimals: true), '৳ 50,000');
    });

    test('Bengali digits', () {
      expect(formatPoisha(5000000, bengaliDigits: true), '৳ ৫০,০০০.০০');
    });

    test('round trip through input text', () {
      for (final p in [1, 99, 100, 123450, 5000000, 987654321]) {
        expect(parsePoisha(poishaToInput(p)).poisha, p);
        expect(parsePoisha(formatPoisha(p)).poisha, p);
        expect(parsePoisha(formatPoisha(p, bengaliDigits: true)).poisha, p);
      }
    });
  });
}
