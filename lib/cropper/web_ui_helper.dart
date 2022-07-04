import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_cropper_for_web/image_cropper_for_web.dart';

List<PlatformUiSettings>? buildUiSettings(BuildContext context) {
  final Size size = MediaQuery.of(context).size;
  final bw = (520 < size.width.toInt()) ? 520 : size.width.toInt() - 200;
  final vw = (bw * 0.9).toInt();
  return [
    WebUiSettings(
      context: context,
      presentStyle: CropperPresentStyle.dialog,
      boundary: Boundary(
        width: bw,
        height: bw,
      ),
      viewPort: ViewPort(width: vw, height: vw, type: 'square'),
      enableExif: true,
      enableZoom: true,
      showZoomer: true,
    ),
  ];
}
