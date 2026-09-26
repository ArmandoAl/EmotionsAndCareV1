import 'package:fl_chart/fl_chart.dart';

import '../helpers/paths.dart';

Widget containerNoteContentWidget(BuildContext context, NoteModel? note) {
  if (note == null) {
    return ListView(
      children: [
        Text("Simbología",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: AppColors.shadowWarm)),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: emotionColors.keys.map((e) {
            return Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: emotionColors[e]!.withOpacity(0.85),
                borderRadius: BorderRadius.circular(AppRadius.md),
                boxShadow: AppShadows.soft,
              ),
              child: Center(
                child: Text(
                  e,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: AppColors.shadowWarm),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  } else {
    return ListView(
      children: [
        Row(
          children: [
            Text(note.emotion.icon!, style: const TextStyle(fontSize: 34)),
            const Spacer(),
            Text(
              "${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.shadowWarm),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Text("Título",
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: AppColors.shadowWarm)),
        const SizedBox(height: AppSpacing.xs),
        Text(note.title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppColors.shadowWarm)),
        const SizedBox(height: AppSpacing.xl),
        Text("Contenido",
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: AppColors.shadowWarm)),
        const SizedBox(height: AppSpacing.xs),
        Text(note.content,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppColors.shadowWarm)),
      ],
    );
  }
}

Widget noteItem(
  BuildContext context,
  NoteModel note,
) {
  return GestureDetector(
    child: Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(3.0),
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          width: MediaQuery.of(context).size.width * 0.15,
          decoration: BoxDecoration(
            color: emotionColors[note.emotion.name],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 15,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.daySurface.withOpacity(0.7),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
            child: Text(
              "${note.createdAt.day}/${note.createdAt.month}",
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: AppColors.shadowWarm),
            ),
          ),
        )
      ],
    ),
  );
}

int calculateWeeks(List<NoteModel> notes) {
  //calcular cuantas semanas hay en las notas

  final weeks = <int>{};
  for (var note in notes) {
    weeks.add(note.createdAt.weekday ~/ 7);
  }

  return weeks.length;
}

Widget emotionsForWeekWidgetForStaticts(
  BuildContext context,
  Map<String, List<NoteModel>> notasPorSemana,
  int index,
) {
  //toma todas las notas de la semana, y las agrupa por emocion para mostrarlas, muestralas en grafica de barras
  final semana = notasPorSemana.keys
      .toList()[index]; // Obtener la clave (nombre de semana) en el índice dado
  final notesForWeek = notasPorSemana[semana]!;
  final staticsMap = <String, int>{};

  for (var note in notesForWeek) {
    if (staticsMap.containsKey(note.emotion.name)) {
      staticsMap[note.emotion.name] = staticsMap[note.emotion.name]! + 1;
    } else {
      staticsMap[note.emotion.name] = 1;
    }
  }

  final percentMap = <String, double>{};

  for (var key in staticsMap.keys) {
    percentMap[key] = staticsMap[key]! / notesForWeek.length;
  }

  return Container(
    width: MediaQuery.of(context).size.width * 0.9,
    height: MediaQuery.of(context).size.height * 0.3,
    margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
    padding: const EdgeInsets.all(AppSpacing.sm),
    decoration: BoxDecoration(
      color: AppColors.daySurface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      boxShadow: AppShadows.soft,
    ),
    child: Column(
      children: [
        const SizedBox(height: AppSpacing.xs),
        Text(
          semana,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: AppColors.shadowWarm),
        ),
        const SizedBox(height: AppSpacing.xs),
        Expanded(
            child: PieChart(
          PieChartData(
            sections: percentMap.keys
                .map((e) => PieChartSectionData(
                      value: percentMap[e]!,
                      color: emotionColors[e]!.withOpacity(0.85),
                      //put the emotion icon in the center of the pie chart
                      title: emotionIcons[e],
                      titleStyle: TextStyle(
                        color: AppColors.shadowWarm,
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                      ),
                      radius: MediaQuery.of(context).size.width * 0.1,
                    ))
                .toList(),
          ),
        ))
      ],
    ),
  );
}

Widget percentWidget(BuildContext context, double percent, Color color) {
  final percentHeight = MediaQuery.of(context).size.height * 0.18 * percent;

  return Container(
      width: MediaQuery.of(context).size.width * 0.1,
      height: percentHeight,
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Center(
        child: Text(
          "${(percent * 100).toStringAsFixed(2)}%",
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: AppColors.shadowWarm),
        ),
      ));
}

Widget emotionsForWeekWidget(
  BuildContext context,
  int index,
  Map<String, List<NoteModel>> notasPorSemana,
) {
  final semana = notasPorSemana.keys.toList()[index];
  final notesForWeek = notasPorSemana[semana]!;

  return Container(
    width: MediaQuery.of(context).size.width * 0.95,
    height: MediaQuery.of(context).size.height * 0.3,
    margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
    decoration: BoxDecoration(
      color: AppColors.daySurface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      boxShadow: AppShadows.soft,
    ),
    child: Column(
      children: [
        const SizedBox(height: AppSpacing.sm),
        Text(
          semana,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: AppColors.shadowWarm),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: Row(
            children: [
              for (int i = 0; i < 7; i++)
                Expanded(
                  child: notesForDayWidget(context, notesForWeek, i),
                ),
            ],
          ),
        )
      ],
    ),
  );
}

Widget notesForDayWidget(
  BuildContext context,
  List<NoteModel> notesForDay,
  int dayIndex,
) {
  final notesDay = notesForDay
      .where((element) => element.createdAt.weekday == dayIndex + 1)
      .toList();

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
    child: Column(
      children: [
        const SizedBox(height: AppSpacing.sm),
        Text(
          days[dayIndex % 7],
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: AppColors.shadowWarm),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: notesDay.length,
            itemBuilder: (context, index) {
              return notePerDay(context, notesDay, index);
            },
          ),
        ),
      ],
    ),
  );
}

Widget notePerDay(BuildContext context, List<NoteModel> notes, int index) {
  return GestureDetector(
    onTap: () async {
      await showNoteInfoFromBottomShet(context, notes[index]);
    },
    child: Center(
      child: Text(notes[index].emotion.icon!,
          style: const TextStyle(fontSize: 20)),
    ),
  );
}

const List<String> days = ["L", "M", "M", "J", "V", "S", "D"];

Future<void> showNoteInfoFromBottomShet(
    BuildContext context, NoteModel note) async {
  await showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.8,
        width: double.infinity,
        decoration: BoxDecoration(
          color: emotionColors[note.emotion.name]!.withOpacity(0.25),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppRadius.xl),
            topRight: Radius.circular(AppRadius.xl),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.lg),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Título: ${note.title}",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: AppColors.shadowWarm),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          "Fecha: ${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.shadowWarm),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          "Emoción: ${note.emotion.name}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.shadowWarm),
                        ),
                      ],
                    ),
                  ),
                  Text(note.emotion.icon!, style: const TextStyle(fontSize: 34)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: SingleChildScrollView(
                  child: Text(
                    textAlign: TextAlign.justify,
                    note.content,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: AppColors.shadowWarm),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

int getWeekNumber(DateTime date) {
  DateTime firstDayOfYear = DateTime(date.year, 1, 1).toLocal();
  int days = date.difference(firstDayOfYear).inDays;
  int weeknumber = ((days - date.weekday + 10) / 7).floor();

  return weeknumber;
}

// Función para separar las notas por semana y día
Map<String, Map<String, List<NoteModel>>> separarNotasPorSemanaYDia(
    List<NoteModel> notas) {
  Map<String, Map<String, List<NoteModel>>> notasSeparadas = {};

  for (var nota in notas) {
    // Obtener el número de semana y el día de la nota
    String semana = '${getWeekNumber(nota.createdAt)}';
    String dia =
        '${nota.createdAt.year}-${nota.createdAt.month}-${nota.createdAt.day}';

    // Crear la estructura de datos si no existe
    notasSeparadas.putIfAbsent(semana, () => {});
    notasSeparadas[semana]?.putIfAbsent(dia, () => []);

    // Agregar la nota a la semana y día correspondientes
    notasSeparadas[semana]![dia]!.add(nota);
  }

  return notasSeparadas;
}

Map<String, List<NoteModel>> organizarNotasPorSemana(
    Map<String, Map<String, List<NoteModel>>> notasSeparadas) {
  Map<String, List<NoteModel>> notasPorSemana = {};

  // Obtener todas las claves (números de semana) y ordenarlas
  List<String> semanasOrdenadas = notasSeparadas.keys.toList();
  semanasOrdenadas.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

  // Iterar sobre las semanas ordenadas
  for (int i = 0; i < semanasOrdenadas.length; i++) {
    String semana = semanasOrdenadas[i];
    String semanaNombre = 'Semana ${i + 1}';

    // Agregar las notas de la semana al mapa organizado por semana
    notasPorSemana.putIfAbsent(semanaNombre, () => []);

    // Iterar sobre los días en la semana actual
    notasSeparadas[semana]!.forEach((dia, notas) {
      notasPorSemana[semanaNombre]!.addAll(notas);
    });
  }

  return notasPorSemana;
}
