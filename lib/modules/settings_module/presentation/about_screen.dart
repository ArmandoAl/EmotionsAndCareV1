import 'package:flutter/material.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_spacing.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emotions&Care'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: ListView(
          children: [
            Text(aboutText,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.shadowWarm)),
          ],
        ),
      ),
    );
  }
}

String aboutText = '''
Emotions&Care es una aplicación desarrollada por Tech4Good Research Lab, dirigida por la Dra. Karina Caro åCorrales.

Equipo de Desarrollo
- Líder de proyecto: Karina Caro Corrales
- Analistas de Business Intelligence: Pedro David Guevara Rodriguez, Karen Lucía García Ramírez
- Desarrollador Principal: José Armando Alvarado Loaiza
- Desarrollador de Backend: Martin Ortiz Gerardo
- Desarrollador de Frontend: Hazael Gonzalo Espinoza Lara
- Diseño de Interfaz: Martin Ortiz Gerardo, Diego Alberto Pimentel López
- Consultora de Temas de Salud Mental: Sherlyn Haydee Hernández Chávez
- Retroalimentación de Proyecto (documentación, código, flujo): Héctor Zatarain Aceves
- Logo: Mayra Selene Aviña Morales
- Diseño: David Garibay
- Íconos: Diego Alberto Pimentel López

Agradecimientos Especiales a
- Brenda Janeth Ramirez Flores
- Xochitl Hernandez Gonzalez
- Arath Zahid Jesus Castro

1. Protección de Datos Personales
-Ley Federal de Protección de Datos Personales en Posesión de los Particulares (LFPDPPP)
Dado que Emotions&Care opera en México y maneja datos personales sensibles, como resultados de evaluaciones psicométricas, es necesario cumplir con la LFPDPPP. Esta ley regula cómo las entidades privadas deben recopilar, manejar y proteger los datos personales.
Aspectos clave a incluir:
Responsable del tratamiento de datos: Emotions&Care será responsable del tratamiento y protección de los datos personales de los usuarios.
Datos sensibles: Los datos relacionados con la salud mental, como resultados de evaluaciones psicométricas, son considerados datos sensibles bajo la LFPDPPP, lo que requiere un mayor nivel de protección y tratamiento.
Derechos ARCO: Los usuarios tienen derecho a acceder, rectificar, cancelar y oponerse al tratamiento de sus datos personales. El marco legal de la app debe garantizar que los usuarios puedan ejercer estos derechos de manera efectiva.

-Consentimiento Informado y Uso de Datos con Fines Académicos
El uso de los datos por parte de Tech4Good Research Lab con fines académicos es un aspecto clave del funcionamiento de la app. Para cumplir con la LFPDPPP, el marco legal debe incluir un consentimiento informado explícito, donde se le comunique al usuario que sus datos serán utilizados para investigación académica.
Se deberá asegurar que el tratamiento de estos datos cumpla con las siguientes pautas:
Transparencia: Informar claramente al usuario que sus datos serán utilizados con fines de investigación académica.
Autorización explícita: Obtener un consentimiento expreso, por escrito o digital, que autorice el uso de sus datos personales con este propósito.

-Seguridad de los Datos
La protección de los datos de los usuarios es crucial para garantizar su privacidad y cumplir con las normativas aplicables. Emotions&Care debe implementar medidas técnicas y administrativas que aseguren la confidencialidad de la información.
Entre las medidas de seguridad requeridas están:
Cifrado de datos sensibles: Todos los datos relacionados con la salud mental de los usuarios deben ser cifrados tanto en tránsito como en almacenamiento.
Actualizaciones y parches: El sistema debe mantenerse actualizado con las últimas medidas de seguridad.
Monitoreo de vulnerabilidades: Se deben implementar mecanismos para monitorear la plataforma y prevenir posibles brechas de seguridad.
-Notificación de Brechas de Seguridad
El marco legal debe incluir un protocolo de notificación de brechas de seguridad. Si los datos de los usuarios se ven comprometidos, Emotions&Care deberá notificar a las autoridades competentes (INAI) y a los usuarios afectados en un plazo determinado.

2. Responsabilidad Médica y Profesional
-Exclusión de Diagnóstico Médico
Emotions&Care debe aclarar que no proporciona un diagnóstico médico formal. Las herramientas psicométricas, como el Inventario de Depresión de Beck (BDI-2), se utilizan únicamente como apoyo para la autoevaluación de riesgos, pero no pueden ser consideradas como una evaluación profesional.
El marco legal debe incluir un descargo de responsabilidad médico que establezca lo siguiente:
Uso orientativo: Los resultados de las autoevaluaciones son solo para guiar al usuario y sugerir la consulta con un especialista.
Consulta con profesionales: Se recomienda que los usuarios que presenten síntomas consulten a un profesional calificado en salud mental.

-Responsabilidad por Daño Emocional
Aunque Emotions&Care no diagnostica ni trata condiciones de salud mental, es posible que los usuarios experimenten angustia emocional al interpretar sus resultados. El marco legal debe incluir una limitación de responsabilidad respecto a cualquier daño emocional o psicológico derivado del uso de la aplicación.

3. Propiedad Intelectual
-Registro de Derechos de Autor
Dado que Emotions&Care involucra la creación de software, contenido psicométrico y diseño de interfaces, es importante proteger todos los elementos originales a través del registro de derechos de autor. Esto incluye:
Código fuente: El software de la aplicación.
Diseño de interfaz: Gráficos, diseño y arquitectura de la interfaz.
Logotipos y contenido: Cualquier marca gráfica o textual utilizada en la aplicación.
El marco legal debe aclarar que todos los derechos sobre la aplicación son propiedad de Tech4Good Research Lab o de los desarrolladores responsables.

-Licencias de Software
Si Emotions&Care utiliza software o bibliotecas de terceros, es importante cumplir con las licencias aplicables, ya sean de código abierto o comerciales. El marco legal debe establecer que el uso de dichas herramientas está sujeto a las licencias correspondientes.

4. Manejo de Datos de Menores de Edad
-Consentimiento Parental
Si Emotions&Care es utilizada por menores de edad, se debe obtener el consentimiento parental para el uso de la aplicación y el tratamiento de datos personales. El marco legal debe:
Asegurar que ningún menor de edad pueda utilizar la app sin el consentimiento expreso de sus padres o tutores.
Explicar claramente cómo se protegerán los datos de los menores y cómo se utilizarán en la plataforma.

-Protección de Datos de Menores
El tratamiento de los datos de menores debe seguir normativas estrictas, y el marco legal debe incluir una política específica que cubra el manejo de estos datos. Entre las consideraciones están:
Mayor nivel de protección: Los datos de menores deben tener un nivel más alto de seguridad que los datos de adultos.
Control parental: Los padres o tutores deben poder acceder y controlar los datos del menor, así como revocar el acceso cuando lo consideren necesario.

5. Enlaces a Terceros
-Calidad y Ética de los Terceros
Emotions&Care ofrece enlaces a especialistas en salud mental. El marco legal debe especificar que, si bien se verifica la calidad de los profesionales, Tech4Good Research Lab no se hace responsable de los servicios proporcionados por terceros.
Se sugiere incluir una cláusula que permita a la aplicación eliminar cualquier enlace a terceros si estos no cumplen con los estándares de calidad o ética profesional que la plataforma exige.

6. Modificaciones y Actualizaciones de los Términos y Condiciones
El marco legal debe establecer que Tech4Good Research Lab puede modificar los términos y condiciones, así como el aviso de privacidad, y que los usuarios serán notificados de cualquier cambio a través de un correo electrónico.
Esta notificación permitirá a los usuarios estar informados sobre cualquier ajuste en el manejo de sus datos o en las responsabilidades y limitaciones de la aplicación.

7. Normativa de Comercio Electrónico (Si aplica)
En caso de que Emotions&Care ofrezca servicios pagados o suscripciones, será necesario cumplir con la Ley Federal de Protección al Consumidor y otras normativas sobre comercio electrónico en México.

-Seguridad de los Pagos
Si Emotions&Care implementa pagos dentro de la aplicación, es fundamental que el procesamiento de pagos cumpla con las normativas de seguridad y protección de datos financieros. El marco legal debe incluir las siguientes disposiciones:
Procesamiento seguro de pagos: Los pagos deben realizarse a través de plataformas seguras y cumplir con estándares de seguridad como PCI DSS (Payment Card Industry Data Security Standard) para proteger la información financiera del usuario.
Proveedores de pagos de terceros: Si los pagos son procesados por un proveedor externo (como PayPal, Stripe, etc.), el marco legal debe especificar que Emotions&Care no guarda la información financiera del usuario y que dicha información está sujeta a los términos y condiciones del proveedor de pagos.
Política de reembolsos: Es necesario incluir una política clara de reembolsos que describa las condiciones bajo las cuales los usuarios pueden solicitar la devolución de su dinero en caso de que los servicios no cumplan con sus expectativas o en situaciones de cancelaciones de citas con especialistas.

8. Jurisdicción y Resolución de Conflictos
-Leyes Aplicables
El marco legal de Emotions&Care debe especificar la jurisdicción bajo la cual operará la aplicación y qué leyes se aplicarán en caso de conflictos legales. Como la app opera principalmente en México, estará sujeta a la legislación mexicana, especialmente a las normativas de protección de datos, comercio electrónico y salud.

Sin embargo, si Emotions&Care llega a operar en otros países o regiones, deberá cumplir con las leyes locales aplicables a protección de datos y servicios digitales. Esto incluye regulaciones como:
Reglamento General de Protección de Datos (GDPR) en caso de usuarios europeos.
Health Insurance Portability and Accountability Act (HIPAA) en caso de manejar usuarios en Estados Unidos que puedan estar sujetos a regulaciones relacionadas con la información médica.

-Mecanismos de Resolución de Conflictos
El marco legal también debe detallar cómo se resolverán los conflictos entre los usuarios y la plataforma. Se puede optar por mecanismos de resolución alternativa de disputas, como mediación o arbitraje, para evitar litigios costosos.

Entre las disposiciones a incluir están:
Elección de foro: Se especificará que cualquier disputa relacionada con el uso de la app se resolverá en los tribunales de una jurisdicción particular (por ejemplo, los tribunales de Baja California, México).
Mediación o arbitraje: Antes de recurrir a una demanda judicial, se ofrecerá la posibilidad de resolver disputas mediante mediación o arbitraje.
Costos legales: Se debe especificar si la parte perdedora será responsable de cubrir los costos legales de la parte ganadora en caso de un litigio.
9. Aviso de Privacidad

-Definición del Aviso de Privacidad
El Aviso de Privacidad es un documento clave que debe ser accesible para todos los usuarios de Emotions&Care. Este aviso debe explicar de manera clara y detallada cómo se recopilan, utilizan y protegen los datos personales de los usuarios, cumpliendo con las obligaciones establecidas por la Ley Federal de Protección de Datos Personales en Posesión de los Particulares (LFPDPPP).

-Contenido Obligatorio del Aviso de Privacidad
El aviso debe incluir:
Identidad del responsable: Se debe informar a los usuarios quién es el responsable de la recopilación y tratamiento de los datos personales.
Finalidades del tratamiento de datos: Se deben especificar claramente los fines con los que se recopilan los datos, incluyendo los fines de investigación académica realizados por el Tech4Good Research Lab.
Transferencias de datos: Se debe indicar si los datos serán compartidos con terceros, en qué condiciones y con qué propósito. En este caso, los usuarios serán informados de que sus datos podrán ser utilizados para investigaciones académicas, pero no se compartirán con otros especialistas sin su consentimiento expreso.
Ejercicio de los Derechos ARCO: Se debe proporcionar un mecanismo para que los usuarios puedan ejercer sus derechos de Acceso, Rectificación, Cancelación y Oposición al tratamiento de sus datos personales.
Actualizaciones del Aviso de Privacidad: El aviso debe incluir una cláusula que permita a Emotions&Care modificar el contenido del aviso, con el compromiso de notificar a los usuarios por correo electrónico en caso de cambios importantes.

-Consentimiento del Usuario
El usuario debe aceptar el aviso de privacidad antes de utilizar la aplicación. Este consentimiento debe ser explícito, y el marco legal debe garantizar que la aceptación del aviso esté registrada digitalmente como parte del uso de la plataforma.

10. Términos y Condiciones
-Alcance de los Términos y Condiciones
Los Términos y Condiciones son el contrato entre Emotions&Care y sus usuarios. Este documento regula el uso de la plataforma, estableciendo los derechos y responsabilidades de ambas partes.

-Contenido de los Términos y Condiciones
Los términos deben incluir, pero no limitarse a:
Aceptación del uso de los datos con fines académicos: Se incluirá una cláusula que establezca que, al aceptar los Términos y Condiciones, el usuario consiente que sus datos se utilicen con fines de investigación por el Tech4Good Research Lab.
Obligaciones del usuario: Se especificarán las conductas prohibidas dentro de la aplicación, como el uso indebido de los servicios o la falsificación de datos.
Modificaciones de los Términos: Al igual que con el Aviso de Privacidad, Emotions&Care podrá modificar los Términos y Condiciones en cualquier momento, notificando a los usuarios mediante correo electrónico.
Condiciones de uso de los servicios: Se detallarán las condiciones bajo las cuales los usuarios pueden interactuar con especialistas y utilizar las herramientas psicométricas.
Limitación de responsabilidad: Se aclarará que la aplicación no asume responsabilidad por decisiones médicas basadas en los resultados de las autoevaluaciones.

-Notificación de Cambios
Cada vez que se actualicen los Términos y Condiciones, Emotions&Care se compromete a enviar una notificación a los usuarios a través de un correo electrónico. Esto asegura que los usuarios estén informados de cualquier cambio relevante en sus derechos y obligaciones.

11. Cumplimiento con Normativas Internacionales
-Reglamento General de Protección de Datos (GDPR)
Si en algún momento Emotions&Care llega a operar en la Unión Europea, será necesario cumplir con el GDPR, que impone estrictas reglas sobre el manejo de datos personales, incluidos los derechos de los usuarios de:
Acceso y portabilidad de datos.
Borrado de datos.
Rectificación y corrección de datos incorrectos.
El marco legal de la app deberá ajustarse a las regulaciones europeas si el servicio se expande internacionalmente.

-Ley de Portabilidad y Responsabilidad del Seguro de Salud (HIPAA)
Si Emotions&Care gestiona usuarios en Estados Unidos y maneja datos médicos, se requerirá el cumplimiento de HIPAA. Esta normativa se centra en la protección de la información médica sensible y establece estrictos controles sobre cómo se manejan estos datos, en especial por parte de aplicaciones que colaboran con profesionales de la salud.


Página de FCAyS:
© Derechos reservados. Facultad de Ciencias Administrativas y Sociales, 2024.

Página de UABC:
Universidad Autónoma de Baja California © 2024

Propuesta:
© Derechos reservados. Universidad Autónoma de Baja California, Facultad de Ciencias Administrativas y Sociales, 2024.

''';
