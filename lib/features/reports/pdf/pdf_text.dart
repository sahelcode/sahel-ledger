import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart' show Color;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Why this exists
/// ---------------
/// The `pdf` package embeds TrueType fonts but performs no OpenType shaping
/// (no GSUB/GPOS). Bengali needs shaping: conjuncts (ক্ষ, ন্ত), reordered
/// vowel signs (ি, ে, ৈ appear *before* the consonant) and split vowels
/// (ো, ৌ). Drawn as raw glyphs, Bengali text in a PDF is visibly wrong.
///
/// Flutter's own text engine (HarfBuzz) shapes Bengali correctly, so runs
/// that contain Bengali letters are laid out by Flutter and embedded as
/// high-resolution images. Everything else (Latin text, ASCII and Bengali
/// digits, the ৳ sign, numbers in tables) stays real, selectable vector
/// text using the same embedded font.
class PdfTextKit {
  PdfTextKit({
    required this.regular,
    required this.bold,
    required this.fontFamily,
    this.scale = 4.0,
  });

  /// Font used for vector text (must contain Latin, Bengali digits and ৳).
  final pw.Font regular;
  final pw.Font bold;

  /// Flutter font family used for shaping Bengali runs.
  final String fontFamily;

  /// Raster scale over PDF points. 4x = 288 dpi, sharp in print.
  final double scale;

  final _cache = <String, _Raster>{};
  int rasterCount = 0;

  static final _complex = RegExp(r'[ঀ-৥ৰ-৲৴-৿]');

  /// True when [s] contains Bengali characters that require shaping.
  static bool needsShaping(String s) => _complex.hasMatch(s);

  pw.TextStyle style({
    double size = 9,
    bool isBold = false,
    PdfColor color = PdfColors.black,
  }) => pw.TextStyle(
    font: isBold ? bold : regular,
    fontBold: bold,
    fontSize: size,
    color: color,
    lineSpacing: 1.5,
  );

  /// A PDF widget showing [text]. [maxWidth] (points) enables wrapping.
  Future<pw.Widget> text(
    String text, {
    double size = 9,
    bool isBold = false,
    PdfColor color = PdfColors.black,
    double? maxWidth,
    pw.TextAlign align = pw.TextAlign.left,
    int? maxLines,
  }) async {
    if (!needsShaping(text)) {
      return pw.Text(
        text,
        style: style(size: size, isBold: isBold, color: color),
        textAlign: align,
        maxLines: maxLines,
      );
    }
    final r = await _raster(
      text,
      size,
      isBold,
      color,
      maxWidth,
      align,
      maxLines,
    );
    return pw.Image(
      pw.MemoryImage(r.png),
      width: r.width,
      height: r.height,
      dpi: 72 * scale,
    );
  }

  Future<_Raster> _raster(
    String text,
    double size,
    bool isBold,
    PdfColor color,
    double? maxWidth,
    pw.TextAlign align,
    int? maxLines,
  ) async {
    final key =
        '$text|$size|$isBold|${color.toInt()}|$maxWidth|$align|$maxLines';
    final hit = _cache[key];
    if (hit != null) return hit;
    final pb =
        ui.ParagraphBuilder(
            ui.ParagraphStyle(
              fontFamily: fontFamily,
              fontSize: size * scale,
              fontWeight: isBold ? ui.FontWeight.w600 : ui.FontWeight.w400,
              height: 1.25,
              maxLines: maxLines,
              ellipsis: maxLines == null ? null : '…',
              textAlign: switch (align) {
                pw.TextAlign.right => ui.TextAlign.right,
                pw.TextAlign.center => ui.TextAlign.center,
                _ => ui.TextAlign.left,
              },
            ),
          )
          ..pushStyle(
            ui.TextStyle(color: Color(color.toInt()), fontFamily: fontFamily),
          )
          ..addText(text);
    final paragraph = pb.build()
      ..layout(ui.ParagraphConstraints(width: (maxWidth ?? 10000) * scale));
    final w = (maxWidth == null ? paragraph.maxIntrinsicWidth : paragraph.width)
        .ceil()
        .clamp(1, 1 << 14);
    final h = paragraph.height.ceil().clamp(1, 1 << 14);
    final recorder = ui.PictureRecorder();
    ui.Canvas(recorder).drawParagraph(paragraph, ui.Offset.zero);
    final image = await recorder.endRecording().toImage(w, h);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    final r = _Raster(bytes!.buffer.asUint8List(), w / scale, h / scale);
    rasterCount++;
    return _cache[key] = r;
  }
}

class _Raster {
  _Raster(this.png, this.width, this.height);
  final Uint8List png;
  final double width;
  final double height;
}
