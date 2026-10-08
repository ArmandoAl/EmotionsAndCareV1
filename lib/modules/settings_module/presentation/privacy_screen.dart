import '../../../helpers/paths.dart';

class PrivacyScreen extends StatefulWidget {
  final PattientSettings? settings;
  const PrivacyScreen({super.key, required this.settings});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  //switch value
  late bool notificationsSwitch = false;
  late bool daitySwitch = false;
  late bool testSwitch = false;

  @override
  void initState() {
    super.initState();
    notificationsSwitch = widget.settings!.notifications;
    daitySwitch = widget.settings!.diaryActivated;
    testSwitch = widget.settings!.testActivated;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacidad'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
          ),
          onPressed: () async {
            final BegginCubit userProvider = getIt<BegginCubit>();
            await userProvider.changePrivacy(
              userProvider.state.patientModel!.id!,
              notificationsSwitch,
              daitySwitch,
              testSwitch,
            );
            if (context.mounted) Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: ListView(
          children: [
            AppCard(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Notificaciones',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: AppColors.shadowWarm),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Switch(
                    value: notificationsSwitch,
                    onChanged: (value) {
                      setState(() {
                        notificationsSwitch = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Diario',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: AppColors.shadowWarm),
                        ),
                        Text(
                          'Tus notas se compartirán con tu especialista',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.shadowWarm.withOpacity(0.7),
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Switch(
                    value: daitySwitch,
                    onChanged: (value) {
                      setState(() {
                        daitySwitch = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cuestionarios',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: AppColors.shadowWarm),
                        ),
                        Text(
                          'Las respuestas de tus cuestionarios se compartirán con tu especialista',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.shadowWarm.withOpacity(0.7),
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Switch(
                    value: testSwitch,
                    onChanged: (value) {
                      setState(() {
                        testSwitch = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
