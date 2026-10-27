import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

/// Registers Hind Siliguri with the Flutter engine (tests use Ahem by
/// default) and returns PDF fonts.
Future<(pw.Font, pw.Font)> loadTestFonts() async {
  ByteData read(String f) =>
      ByteData.sublistView(File('assets/fonts/$f').readAsBytesSync());
  final loader = FontLoader('HindSiliguri')
    ..addFont(Future.value(read('HindSiliguri-Regular.ttf')))
    ..addFont(Future.value(read('HindSiliguri-SemiBold.ttf')));
  await loader.load();
  return (
    pw.Font.ttf(read('HindSiliguri-Regular.ttf')),
    pw.Font.ttf(read('HindSiliguri-SemiBold.ttf')),
  );
}
