import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sahel_ledger/features/reports/pdf/pdf_text.dart';

import '../support/fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('render naive vs shaped Bengali for visual inspection', () async {
    final (regular, bold) = await loadTestFonts();
    final kit = PdfTextKit(
      regular: regular,
      bold: bold,
      fontFamily: 'HindSiliguri',
    );
    const samples = [
      'প্রতিটি টাকার নির্ভুল হিসাব।',
      'বোনের সঞ্চয় — ক্ষতিপূরণ, শিক্ষা, স্বাস্থ্য',
      'কৌশল, পৌঁছানো, রুমার আমানত',
      '৳ ১,২৩,৪৫৬.৭৮ and ৳ 1,23,456.78',
    ];
    final doc = pw.Document();
    final shaped = [for (final s in samples) await kit.text(s, size: 14)];
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'A. Naive vector text (pdf package, no shaping):',
              style: pw.TextStyle(font: regular, fontSize: 10),
            ),
            for (final s in samples)
              pw.Text(s, style: pw.TextStyle(font: regular, fontSize: 14)),
            pw.SizedBox(height: 20),
            pw.Text(
              'B. PdfTextKit (Flutter-shaped):',
              style: pw.TextStyle(font: regular, fontSize: 10),
            ),
            ...shaped,
          ],
        ),
      ),
    );
    final out = File(
      '${Platform.environment['PDF_OUT'] ?? Directory.systemTemp.path}/bengali_experiment.pdf',
    );
    await out.writeAsBytes(await doc.save());
    expect(kit.rasterCount, 3, reason: 'the digits-only line stays vector');
  });
}
