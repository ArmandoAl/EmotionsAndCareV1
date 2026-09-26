import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/assets/assets.dart';
import '../demo_config.dart';

/// Reemplazo drop-in de `SvgPicture.network` usado en toda la app para
/// mostrar flores, stickers y logros que en producción viven en un bucket
/// remoto (Firebase Storage).
///
/// En modo demo esas URLs no existen (no dependemos de nada del backend
/// original), así que en vez de mostrar un ícono roto usamos una
/// ilustración local ya incluida en el bundle. Fuera del modo demo el
/// comportamiento es idéntico al `SvgPicture.network` original.
Widget demoSvg(
  String url, {
  double? width,
  double? height,
  BoxFit fit = BoxFit.contain,
  Widget Function(BuildContext)? placeholderBuilder,
  Color? color,
}) {
  if (kDemoMode) {
    return Image.asset(
      Assets.flower,
      width: width,
      height: height,
      fit: fit,
      color: color,
    );
  }

  // ignore: deprecated_member_use
  return SvgPicture.network(
    url,
    width: width,
    height: height,
    fit: fit,
    placeholderBuilder: placeholderBuilder,
    // ignore: deprecated_member_use
    color: color,
  );
}
