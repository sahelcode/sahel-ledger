/// Money handling for Sahel Ledger.
///
/// All amounts are stored and computed as integer **poisha** (1 Taka = 100
/// poisha). Floating-point values are never used for money. User input is
/// parsed from text directly into poisha without passing through `double`.
library;

/// Largest absolute amount accepted from user input: ৳ 10,000,000,000,000.00
/// (10 trillion Taka). Far beyond any household need and well inside the
/// 2^53 range that is exact in JavaScript-backed systems (Firestore).
const int kMaxPoisha = 1000000000000000;

const _bengaliDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

/// Converts Bengali digits (০-৯) in [input] to ASCII digits.
String normalizeDigits(String input) {
  final buf = StringBuffer();
  for (final rune in input.runes) {
    final idx = rune - 0x09E6;
    if (idx >= 0 && idx <= 9) {
      buf.write(idx);
    } else {
      buf.writeCharCode(rune);
    }
  }
  return buf.toString();
}

/// Converts ASCII digits in [input] to Bengali digits.
String toBengaliDigits(String input) {
  final buf = StringBuffer();
  for (final unit in input.codeUnits) {
    if (unit >= 0x30 && unit <= 0x39) {
      buf.write(_bengaliDigits[unit - 0x30]);
    } else {
      buf.writeCharCode(unit);
    }
  }
  return buf.toString();
}

enum MoneyParseError { empty, invalid, negative, tooManyDecimals, tooLarge }

class MoneyParseResult {
  const MoneyParseResult._(this.poisha, this.error);
  const MoneyParseResult.ok(int poisha) : this._(poisha, null);
  const MoneyParseResult.fail(MoneyParseError error) : this._(null, error);

  final int? poisha;
  final MoneyParseError? error;
  bool get isOk => error == null;
}

/// Parses user-entered text such as `1,234.50`, `৳ ১,২৩৪.৫`, or `1234` into
/// poisha. Grouping commas and spaces are ignored. At most two decimal
/// places are accepted; extra precision is rejected rather than rounded so a
/// user never silently loses money.
MoneyParseResult parsePoisha(String raw, {bool allowZero = false}) {
  var text = normalizeDigits(raw.trim())
      .replaceAll('৳', '')
      .replaceAll('Tk', '')
      .replaceAll('tk', '')
      .replaceAll(',', '')
      .replaceAll(' ', '')
      .replaceAll(' ', '');
  if (text.isEmpty) return const MoneyParseResult.fail(MoneyParseError.empty);
  if (text.startsWith('-')) {
    return const MoneyParseResult.fail(MoneyParseError.negative);
  }
  if (text.startsWith('+')) text = text.substring(1);
  final match = RegExp(r'^(\d*)(?:\.(\d*))?$').firstMatch(text);
  if (match == null) return const MoneyParseResult.fail(MoneyParseError.invalid);
  final whole = match.group(1) ?? '';
  final frac = match.group(2) ?? '';
  if (whole.isEmpty && frac.isEmpty) {
    return const MoneyParseResult.fail(MoneyParseError.invalid);
  }
  if (frac.length > 2) {
    return const MoneyParseResult.fail(MoneyParseError.tooManyDecimals);
  }
  final wholeDigits = whole.replaceFirst(RegExp(r'^0+'), '');
  // 16 digits of taka is already above kMaxPoisha; avoid int overflow.
  if (wholeDigits.length > 14) {
    return const MoneyParseResult.fail(MoneyParseError.tooLarge);
  }
  final taka = wholeDigits.isEmpty ? 0 : int.parse(wholeDigits);
  final poishaPart = int.parse(frac.padRight(2, '0'));
  final total = taka * 100 + poishaPart;
  if (total > kMaxPoisha) {
    return const MoneyParseResult.fail(MoneyParseError.tooLarge);
  }
  if (total == 0 && !allowZero) {
    return const MoneyParseResult.fail(MoneyParseError.invalid);
  }
  return MoneyParseResult.ok(total);
}

/// Groups digits using the South Asian system (lakh/crore): 1,23,45,678.
String _groupIndian(String digits) {
  if (digits.length <= 3) return digits;
  final last3 = digits.substring(digits.length - 3);
  var rest = digits.substring(0, digits.length - 3);
  final parts = <String>[];
  while (rest.length > 2) {
    parts.insert(0, rest.substring(rest.length - 2));
    rest = rest.substring(0, rest.length - 2);
  }
  if (rest.isNotEmpty) parts.insert(0, rest);
  return '${parts.join(',')},$last3';
}

/// Formats [poisha] as Taka, e.g. `৳ 1,23,456.78`.
///
/// * [bengaliDigits] renders ০-৯ instead of 0-9.
/// * [symbol] prefixes the ৳ sign.
/// * [signed] prefixes `+` for positive values (negatives always show `-`).
/// * [compactDecimals] drops `.00` for whole-taka values.
String formatPoisha(
  int poisha, {
  bool bengaliDigits = false,
  bool symbol = true,
  bool signed = false,
  bool compactDecimals = false,
}) {
  final negative = poisha < 0;
  final abs = poisha.abs();
  final taka = abs ~/ 100;
  final paisa = abs % 100;
  var body = _groupIndian(taka.toString());
  if (!(compactDecimals && paisa == 0)) {
    body = '$body.${paisa.toString().padLeft(2, '0')}';
  }
  final sign = negative ? '-' : (signed && poisha > 0 ? '+' : '');
  var out = symbol ? '$sign৳ $body' : '$sign$body';
  if (bengaliDigits) out = toBengaliDigits(out);
  return out;
}

/// Converts poisha to an editable plain string (no grouping, no symbol),
/// e.g. 123450 -> `1234.50`, 100000 -> `1000`.
String poishaToInput(int poisha) {
  final taka = poisha ~/ 100;
  final paisa = poisha % 100;
  return paisa == 0 ? '$taka' : '$taka.${paisa.toString().padLeft(2, '0')}';
}
