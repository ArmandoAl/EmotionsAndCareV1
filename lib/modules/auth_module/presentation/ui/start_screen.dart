import 'package:flutter/material.dart';

import '../../../../config/assets/assets.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_spacing.dart';

class StartScreen extends StatefulWidget {
  final void Function() onTap;
  const StartScreen({super.key, required this.onTap});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
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
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.15,
                decoration: BoxDecoration(
                    color: AppColors.daySecondary.withOpacity(0.5),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(100),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.daySecondary,
                        blurRadius: 15,
                        spreadRadius: 10,
                      )
                    ]),
              )),
          Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                    color: AppColors.dayTertiary.withOpacity(0.5),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      topLeft: Radius.circular(50),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.dayTertiary,
                        blurRadius: 15,
                        spreadRadius: 10,
                      )
                    ]),
              )),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Spacer(),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.daySurface,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomLeft: Radius.zero,
                            bottomRight: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowWarm.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 5,
                            )
                          ],
                        ),
                        child: Text(
                          '¡Te damos la bienvenida a Emotions&Care!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: AppColors.shadowWarm),
                        )),
                    const SizedBox(width: AppSpacing.lg),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.logo),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Text("¡Estamos aquí para apoyarte en cada paso del camino!",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                        )),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ElevatedButton(
                  onPressed: widget.onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.daySurface,
                    foregroundColor: AppColors.dayPrimary,
                    elevation: 6,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xxl, vertical: AppSpacing.md),
                  ),
                  child: Text('Iniciar',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: AppColors.dayPrimary)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
