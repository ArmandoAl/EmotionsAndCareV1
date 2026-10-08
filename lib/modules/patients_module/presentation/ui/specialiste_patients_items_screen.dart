import '../../../../helpers/paths.dart';
import '../../../../widgets/header_specialist_widget.dart';

class SpecialisPattientsScreen extends StatefulWidget {
  final String title;
  final List<PatientModel> pattients;
  final Function(PatientModel) onItemTap;
  final int userId;
  const SpecialisPattientsScreen(
      {super.key,
      required this.title,
      required this.onItemTap,
      required this.pattients,
      required this.userId});

  @override
  State<SpecialisPattientsScreen> createState() =>
      _SpecialisPattientsScreenState();
}

class _SpecialisPattientsScreenState extends State<SpecialisPattientsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderSpecialistWidget(
          title: widget.title, isForReturn: true, context: context),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<PattientsCubit>().getPattients(widget.userId);
          },
          child: widget.pattients.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: 80),
                    AppEmptyState(
                      icon: Icons.people_outline_rounded,
                      title: 'Aún no tienes pacientes',
                      message:
                          'Comparte tu código de vinculación desde configuración para empezar.',
                    ),
                  ],
                )
              : ListView(
                  children:
                      itemsList(context, widget.pattients, widget.onItemTap),
                ),
        ),
      ),
    );
  }
}

List<Widget> itemsList(
    BuildContext context, List<PatientModel> pattients, Function onTap) {
  final List<Widget> list = [];

  list.add(const SizedBox(height: AppSpacing.sm));
  for (final PatientModel pattient in pattients) {
    list.add(containerItem(
      context,
      Colors.white,
      pattient.name!,
      pattient.email!,
      pattient.sex ?? '',
      () {
        onTap(pattient);
      },
    ));

    list.add(const SizedBox(height: AppSpacing.sm));
  }
  return list;
}
