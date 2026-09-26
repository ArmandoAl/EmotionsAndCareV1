import 'package:flutter/material.dart';
import '../../../../config/assets/assets.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../widgets/design_system/app_button.dart';

class CommunityMenuScreen extends StatefulWidget {
  final void Function() onCartsTap;
  final void Function() onPostsTap;
  final void Function() onCartFromUserTap;
  const CommunityMenuScreen(
      {super.key,
      required this.onCartsTap,
      required this.onPostsTap,
      required this.onCartFromUserTap});

  @override
  State<CommunityMenuScreen> createState() => _CommunityMenuScreenState();
}

class _CommunityMenuScreenState extends State<CommunityMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          GestureDetector(
            onTap: widget.onCartsTap,
            child: Stack(children: [
              Image.asset(
                Assets.menuCarta,
                width: MediaQuery.of(context).size.width * 0.8,
              ),
            ]),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.065),
          // Padding(
          //     padding: EdgeInsets.symmetric(
          //         horizontal: MediaQuery.of(context).size.width * 0.07),
          //     child: GestureDetector(
          //       onTap: () async {
          //         await showCommingSoonDialog(context);
          //       },
          //       child: Image.asset(
          //         Assets.menuPost,
          //         width: MediaQuery.of(context).size.width * 0.8,
          //       ),
          //     )),
        ],
      ),
    );
  }
}

Future<void> showCommingSoonDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: Text('Próximamente',
            style: Theme.of(context).textTheme.titleLarge),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                  'Esta funcionalidad estará disponible en futuras actualizaciones.',
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        actions: <Widget>[
          AppButton.text(
            label: 'Aceptar',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
