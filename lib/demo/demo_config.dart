/// Bandera global del modo demo público.
///
/// Se activa exclusivamente en tiempo de compilación con:
///   flutter build web --dart-define=DEMO_MODE=true
///
/// Con el valor por defecto (false) el comportamiento de la app es
/// exactamente el de producción: Firebase se inicializa, se usan los
/// repositorios reales contra la API y el login es obligatorio.
const bool kDemoMode = bool.fromEnvironment('DEMO_MODE', defaultValue: false);

/// Nombre visible del "estudiante" ficticio usado en la demo.
const String kDemoPatientName = 'Estudiante Demo';

/// Texto corto usado en el banner y en los diálogos de la demo.
const String kDemoBannerText = 'MODO DEMOSTRACIÓN · Datos ficticios · Sin conexión al backend';

const String kDemoDisclaimerText =
    'Esta es una demostración pública con datos ficticios. '
    'No representa atención clínica ni resultados reales, y nada de lo '
    'que hagas aquí se guarda en un servidor.';
