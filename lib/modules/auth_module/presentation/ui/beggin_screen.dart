import 'package:flutter/material.dart';

import '../../../../config/assets/assets.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_spacing.dart';

class BegginScreen extends StatefulWidget {
  final void Function() onLogin;
  final void Function() onRegister;
  const BegginScreen(
      {super.key, required this.onLogin, required this.onRegister});

  @override
  State<BegginScreen> createState() => _BegginScreenState();
}

class _BegginScreenState extends State<BegginScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.dayPrimary,
      ),
      child: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: const BoxDecoration(
                  color: AppColors.nightPrimaryContainer,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(500),
                  ),
                ),
              )),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.05,
            left: MediaQuery.of(context).size.width * 0.25,
            child: Image.asset(
              Assets.logo,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
          ),
          Positioned(
              bottom: -MediaQuery.of(context).size.height * 0.05,
              right: MediaQuery.of(context).size.width * 0.1,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: const BoxDecoration(
                    color: AppColors.dayTertiary,
                    borderRadius: BorderRadius.all(Radius.circular(500))),
              )),
          Positioned(
              bottom: -MediaQuery.of(context).size.height * 0.06,
              right: -MediaQuery.of(context).size.width * 0.1,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: const BoxDecoration(
                    color: AppColors.dayTertiary,
                    borderRadius: BorderRadius.all(Radius.circular(500))),
              )),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                ElevatedButton(
                  onPressed: widget.onRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.daySecondary,
                    foregroundColor: Colors.white,
                    elevation: 6,
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md, horizontal: AppSpacing.xxl),
                  ),
                  child: Text('Registrarse',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.white)),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                ElevatedButton(
                  onPressed: widget.onLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.daySurface,
                    foregroundColor: AppColors.dayPrimary,
                    elevation: 6,
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md, horizontal: AppSpacing.xl),
                  ),
                  child: Text('Iniciar sesión',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: AppColors.dayPrimary)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
