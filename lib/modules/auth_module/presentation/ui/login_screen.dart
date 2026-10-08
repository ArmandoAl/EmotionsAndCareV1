import 'package:emotions_and_care_v1/modules/auth_module/presentation/ui/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import '../../../../config/assets/assets.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../widgets/design_system/app_button.dart';

class LoginScreen extends StatefulWidget {
  final Future<void> Function(
      String email, String password, bool isRememberPassword) onLogin;
  final void Function() onRegister;
  final Future<bool> Function(String email) recoverPassword;
  final Future<bool> Function(String mail, String code) validateCode;
  final Future<bool> Function(String mail, String pasword) changePassword;

  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onRegister,
    required this.recoverPassword,
    required this.validateCode,
    required this.changePassword,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = true;
  bool isLoading = false;
  bool isRememberPassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.dayPrimary,
          ),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Image.asset(
                Assets.logo,
                width: MediaQuery.of(context).size.width * 0.3,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.daySurface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.1,
                      vertical: AppSpacing.sm),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        _customTextFieldWidget(
                            context,
                            emailController,
                            'Correo electrónico',
                            const Icon(Icons.email_rounded,
                                color: AppColors.shadowWarm),
                            null, () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        }, TextInputType.emailAddress),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        _customTextFieldWidget(
                            context,
                            passwordController,
                            'Contraseña',
                            const Icon(Icons.lock_rounded,
                                color: AppColors.shadowWarm),
                            isPasswordVisible, () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        }, TextInputType.visiblePassword),
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                // Navegar a la pantalla de recuperación de contraseña
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgotPasswordScreen(
                                      recoverPassword: (String mail) async {
                                        return await widget
                                            .recoverPassword(mail);
                                      },
                                      validateCode:
                                          (String mail, String code) async {
                                        return await widget.validateCode(
                                            mail, code);
                                      },
                                      changePassword:
                                          (String mail, String pasword) async {
                                        return await widget.changePassword(
                                            mail, pasword);
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Text('¿Olvidaste tu contraseña?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(color: AppColors.shadowWarm)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: isRememberPassword,
                                onChanged: (value) {
                                  setState(() {
                                    isRememberPassword = value!;
                                  });
                                }),
                            Text('Recordar contraseña',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.shadowWarm,
                                    )),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                            child: AppButton(
                              expand: true,
                              isLoading: isLoading,
                              label: 'Iniciar sesión',
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                await widget.onLogin(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                    isRememberPassword);
                                setState(() {
                                  isLoading = false;
                                });
                              },
                            ),
                          ),
                        ),
                        Row(children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                            child: Text('O',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppColors.shadowWarm)),
                          ),
                          const Expanded(child: Divider()),
                        ]),
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              Text('¿Eres nuevo? ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(color: AppColors.shadowWarm)),
                              GestureDetector(
                                onTap: () {
                                  widget.onRegister();
                                },
                                child: Text('Regístrate',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary)),
                              ),
                              const Spacer(),
                            ]),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}

Widget _customTextFieldWidget(
    BuildContext context,
    TextEditingController controller,
    String hintText,
    Icon icon,
    bool? oscureText,
    Function() onTap,
    TextInputType? type) {
  return SizedBox(
    child: Column(
      children: [
        Row(
          children: [
            Text(hintText,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: AppColors.shadowWarm)),
            const Spacer()
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: TextField(
                keyboardType: type,
                obscureText: oscureText ?? false,
                controller: controller,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.shadowWarm),
                decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  filled: true,
                  //just border in the bottom of the textfield
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.shadowWarm.withOpacity(0.3)),
                  ),
                  icon: icon,
                ),
              ),
            ),
            oscureText != null
                ? IconButton(
                    onPressed: () {
                      onTap();
                    },
                    icon: Icon(
                      oscureText
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: AppColors.shadowWarm,
                    ),
                  )
                : const SizedBox(
                    width: 0,
                  ),
          ],
        ),
      ],
    ),
  );
}
