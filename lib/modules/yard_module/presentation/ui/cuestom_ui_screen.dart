import 'package:lottie/lottie.dart';
import '../../../../helpers/paths.dart';
import 'maceta_widget.dart';

class CustomUIScreen extends StatefulWidget {
  static const String route = 'home';
  final Function tap;
  final String? registerFlow;
  const CustomUIScreen(
      {super.key, required this.tap, required this.registerFlow});

  @override
  State<CustomUIScreen> createState() => _CustomUIScreenState();
}

class _CustomUIScreenState extends State<CustomUIScreen>
    with TickerProviderStateMixin {
  late UICubit uiProvider;
  late BegginCubit userProvider;

  @override
  void initState() {
    super.initState();
    uiProvider = getIt<UICubit>();
    userProvider = getIt<BegginCubit>();

    if (mounted) {
      if (widget.registerFlow != null &&
          widget.registerFlow != "registerSuccess") {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showMessageDialog(context, "Hora de personalizar",
              "Elige una planta que te acompañará en esta aventura. A medida que avances, tu planta florecerá, reflejando tu progreso.",
              dimiss: false);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: BlocConsumer<UICubit, UIState>(
          bloc: uiProvider,
          listener: (context, state) {},
          builder: (BuildContext context, UIState state) {
            if (state.status == UIStatus.loading) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Emotions&Care',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                home: Scaffold(
                  body: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(Assets.logo),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            }

            return Material(
              child: Stack(
                children: [
                  state.selectedBackground != "null"
                      ? Lottie.asset(
                          uiProvider.state.selectedBackground,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      : const SizedBox(),
                  Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    height: double.infinity,
                    child: PotWidget(
                      customEnable: true,
                      dimissPlane: (bool value) {},
                      state: state,
                      cubit: uiProvider,
                    ),
                  ),
                  Positioned(
                      top: MediaQuery.of(context).size.height * 0.05,
                      left: MediaQuery.of(context).size.width * 0.01,
                      child: Builder(builder: (context) {
                        return IconButton(
                          icon: Icon(Icons.check_circle_rounded,
                              color: Theme.of(context).colorScheme.primary,
                              size: MediaQuery.of(context).size.width * 0.1),
                          onPressed: () async {
                            if (uiProvider.state.currentFlower == null) {
                              await widget.tap();
                              return;
                            }

                            if (context.mounted) Navigator.of(context).pop();
                          },
                        );
                      })),
                ],
              ),
            );
          }),
    );
  }
}
