import 'dart:html' as html;

/// Reinicia la sesión de demostración recargando la página.
///
/// Como todo el estado de la demo vive en memoria (blocs + repositorios en
/// memoria), recargar la página es la forma más simple y confiable de
/// volver exactamente al estado inicial, sin arriesgar estados a medio
/// resetear entre los distintos cubits.
void resetDemoSession() {
  html.window.location.reload();
}
