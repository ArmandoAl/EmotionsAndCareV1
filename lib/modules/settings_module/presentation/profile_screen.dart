import '../../../helpers/paths.dart';

class ProfileScreen extends StatefulWidget {
  final PatientModel? patientModel;
  final SpecialistModel? specialistModel;
  final bool isPatient;
  final BegginCubit userProvider;

  const ProfileScreen(
      {super.key,
      this.patientModel,
      this.specialistModel,
      required this.isPatient,
      required this.userProvider});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController controller = TextEditingController();
  TextEditingController controllerSecondPassword = TextEditingController();
  late PatientModel? patientModel;
  late SpecialistModel? specialistModel;

  @override
  void initState() {
    super.initState();
    patientModel = widget.patientModel;
    specialistModel = widget.specialistModel;
  }

  @override
  void dispose() {
    controller.dispose();
    controllerSecondPassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información personal'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () async {
            if (widget.isPatient) {
              if (patientModel!.isEqual(widget.patientModel!)) {
                Navigator.pop(context);

                return;
              }
            } else {
              if (specialistModel!.isEqual(widget.specialistModel!)) {
                Navigator.pop(context);

                return;
              }
            }

            String res = "success";

            await showLoadingdialog("Cargando datos", context, () async {
              if (widget.isPatient) {
                res = await widget.userProvider.updatePatientData(
                  patientModel!,
                );
              } else {
                res = await widget.userProvider.updateSpecialistData(
                  specialistModel!,
                );
              }

              if (context.mounted) {
                Navigator.pop(context);
              }
            });

            if (res == "success" && context.mounted) {
              await showMessageDialog(context, "", "Datos actualizados",
                  actions: [
                    AppButton.text(
                      label: "Aceptar",
                      onPressed: () {
                        Navigator.pop(context);
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ]);
            } else {
              if (context.mounted) {
                await showMessageDialog(context, "Error", res, actions: [
                  AppButton.text(
                    label: "Aceptar",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ]);
              }
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Información"),
                    content: const Text(
                        "Para editar tu información, haz clic en el dato que deseas modificar, realiza los cambios y confirma para guardarlos."),
                    actions: <Widget>[
                      AppButton.text(
                        label: 'Ok',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: ListView(
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(Icons.person_rounded,
                      size: 48, color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  "Nombre de usuario",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: AppColors.shadowWarm.withOpacity(0.7)),
                ),
                GestureDetector(
                  onTap: () {
                    showChangeDataDialog(
                        context,
                        widget.isPatient
                            ? patientModel!.name!
                            : specialistModel!.name!,
                        "Nombre de usuario",
                        widget.isPatient ? patientModel! : specialistModel!,
                        controller, () {
                      setState(() {
                        if (widget.isPatient) {
                          patientModel = patientModel!.copyWith(
                            name: controller.text,
                          );
                        } else {
                          specialistModel = specialistModel!.copyWith(
                            name: controller.text,
                          );
                        }
                      });

                      return "success";
                    });
                  },
                  child: Text(
                    widget.isPatient
                        ? textToUpperCateFirstLetter(patientModel!.name!)
                        : textToUpperCateFirstLetter(specialistModel!.name!),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: AppColors.shadowWarm),
                  ),
                ),
                if (!widget.isPatient) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text("Código de vinculación",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.shadowWarm.withOpacity(0.7),
                          )),
                  Text(
                    widget.specialistModel!.tokenForRelate!,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: AppColors.shadowWarm),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            profileItem(
              context,
              widget.isPatient ? patientModel!.email! : specialistModel!.email!,
              "Correo electrónico",
              Icon(Icons.email_rounded,
                  color: Theme.of(context).colorScheme.primary),
              () async {
                await showChangeDataDialog(
                    context,
                    widget.isPatient
                        ? patientModel!.email!
                        : specialistModel!.email!,
                    "Correo electrónico",
                    widget.isPatient ? patientModel! : specialistModel!,
                    controller, () {
                  if (validateEmail(controller.text) == false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("El correo electrónico no es válido"),
                      ),
                    );
                    return "error";
                  }

                  setState(() {
                    if (widget.isPatient) {
                      patientModel = patientModel!.copyWith(
                        email: controller.text,
                      );
                    } else {
                      specialistModel = specialistModel!.copyWith(
                        email: controller.text,
                      );
                    }
                  });

                  return "success";
                });
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            profileItem(
              context,
              widget.isPatient ? patientModel!.phone! : specialistModel!.phone!,
              "Teléfono",
              Icon(Icons.phone_rounded,
                  color: Theme.of(context).colorScheme.primary),
              () async {
                await showChangeDataDialog(
                    context,
                    widget.isPatient
                        ? patientModel!.phone!
                        : specialistModel!.phone!,
                    "Teléfono",
                    widget.isPatient ? patientModel! : specialistModel!,
                    controller, () {
                  if (controller.text.length != 10 ||
                      validatePhone(controller.text) == false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("El teléfono no es válido"),
                      ),
                    );
                    return "error";
                  }

                  setState(() {
                    if (widget.isPatient) {
                      patientModel = patientModel!.copyWith(
                        phone: controller.text,
                      );
                    } else {
                      specialistModel = specialistModel!.copyWith(
                        phone: controller.text,
                      );
                    }
                  });

                  return "success";
                });
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            profileItem(
              context,
              widget.isPatient
                  ? patientModel!.age.toString()
                  : specialistModel!.age.toString(),
              "Edad",
              Icon(Icons.cake_rounded,
                  color: Theme.of(context).colorScheme.primary),
              () async {
                await showChangeDataDialog(
                    context,
                    widget.isPatient
                        ? patientModel!.age.toString()
                        : specialistModel!.age.toString(),
                    "Edad",
                    widget.isPatient ? patientModel! : specialistModel!,
                    controller, () {
                  if (int.parse(controller.text) < 17 ||
                      int.parse(controller.text) > 100) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("La edad no es válida"),
                      ),
                    );
                    return "error";
                  }

                  setState(() {
                    if (widget.isPatient) {
                      patientModel = patientModel!.copyWith(
                        age: int.parse(controller.text),
                      );
                    } else {
                      specialistModel = specialistModel!.copyWith(
                        age: int.parse(controller.text),
                      );
                    }
                  });

                  return "success";
                });
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            profileItem(
              context,
              widget.isPatient
                  ? patientModel!.password!
                  : specialistModel!.password!,
              "Contraseña",
              Icon(Icons.lock_rounded,
                  color: Theme.of(context).colorScheme.primary),
              () async {
                await showChangePasswordDialog(
                    context,
                    widget.isPatient
                        ? patientModel!.password!
                        : specialistModel!.password!,
                    "Contraseña",
                    widget.isPatient ? patientModel! : specialistModel!,
                    widget.isPatient,
                    widget.userProvider,
                    controller,
                    controllerSecondPassword);
              },
            ),
            if (!widget.isPatient) ...[
              const SizedBox(height: AppSpacing.xl),
              profileItem(
                  context,
                  specialistModel!.ubication == ""
                      ? "No especificado"
                      : specialistModel!.ubication!,
                  "Ubicación",
                  Icon(Icons.location_on_rounded,
                      color: Theme.of(context).colorScheme.primary), () async {
                await showChangeDataDialog(
                    context,
                    widget.specialistModel!.ubication!,
                    "Ubicación",
                    specialistModel!,
                    controller, () {
                  setState(() {
                    specialistModel = specialistModel!.copyWith(
                      ubication: controller.text,
                    );
                  });

                  return "success";
                });
              }),
              const SizedBox(height: AppSpacing.xl),
              profileItem(
                context,
                specialistModel!.presentation == ""
                    ? "No especificado"
                    : specialistModel!.presentation!,
                "Institución",
                Icon(Icons.business_rounded,
                    color: Theme.of(context).colorScheme.primary),
                () async {
                  await showChangeDataDialog(
                      context,
                      specialistModel!.presentation!,
                      "Institución",
                      specialistModel!,
                      controller, () {
                    setState(() {
                      specialistModel = specialistModel!.copyWith(
                        presentation: controller.text,
                      );
                    });

                    return "success";
                  });
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              profileItem(
                context,
                specialistModel!.focus!,
                "Enfoque",
                Icon(Icons.psychology_rounded,
                    color: Theme.of(context).colorScheme.primary),
                () async {
                  await showChangeDataDialog(
                      context,
                      specialistModel!.focus!,
                      "Enfoque",
                      specialistModel!,
                      controller, () {
                    setState(() {
                      specialistModel = specialistModel!.copyWith(
                        focus: controller.text,
                      );
                    });

                    return "success";
                  });
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              profileItem(
                context,
                specialistModel!.institution == ""
                    ? "No especificado"
                    : specialistModel!.institution!,
                "Carta de presentación",
                Icon(Icons.description_rounded,
                    color: Theme.of(context).colorScheme.primary),
                () async {
                  await showChangeDataDialog(
                      context,
                      specialistModel!.institution!,
                      "Carta de presentación",
                      specialistModel!,
                      controller, () {
                    setState(() {
                      specialistModel = specialistModel!.copyWith(
                        institution: controller.text,
                      );
                    });

                    return "success";
                  });
                },
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    showDeleteUserDialog(context, widget.userProvider);
                  },
                  child: Text(
                    "Eliminar cuenta",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(context).colorScheme.error,
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

Widget profileItem(BuildContext context, String text, String title, Icon? icon,
    Function onPress) {
  return AppCard(
    onTap: () {
      onPress();
    },
    child: Row(
      children: [
        if (icon != null) ...[icon, const SizedBox(width: AppSpacing.md)],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: AppColors.shadowWarm.withOpacity(0.7)),
              ),
              Text(
                title == "Contraseña" ? "********" : text,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.shadowWarm),
              ),
            ],
          ),
        ),
        Icon(Icons.chevron_right_rounded,
            color: AppColors.shadowWarm.withOpacity(0.4)),
      ],
    ),
  );
}

Future<void> showChangeDataDialog(
  BuildContext context,
  String text,
  String title,
  dynamic model,
  TextEditingController controller,
  Function onPress,
) {
  controller.text = text;
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Cambiar $title"),
        content: TextField(
          keyboardType:
              title == "Teléfono" ? TextInputType.phone : TextInputType.text,
          controller: controller,
          decoration: InputDecoration(hintText: "Nuevo $title"),
        ),
        actions: <Widget>[
          AppButton.text(
            label: 'Cancelar',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          AppButton(
            label: 'Aceptar',
            onPressed: () async {
              if (controller.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("El campo no puede estar vacío"),
                  ),
                );
                return;
              }

              if (text == controller.text) {
                Navigator.of(context).pop();
                return;
              }

              String result = await onPress();

              if (context.mounted && result == "success") {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}

Future<void> showChangePasswordDialog(
  BuildContext context,
  String text,
  String title,
  dynamic model,
  bool isPatient,
  BegginCubit userProvider,
  TextEditingController controller,
  TextEditingController controllerP,
) {
  final TextEditingController controller = TextEditingController();
  controller.text = text;
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Cambiar $title"),
        content: TextField(
          obscureText: true,
          controller: controller,
          decoration: InputDecoration(hintText: "Nueva $title"),
        ),
        actions: <Widget>[
          AppButton.text(
            label: 'Cancelar',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          AppButton(
            label: 'Aceptar',
            onPressed: () {
              if (isPatient) {
                // userProvider.updatePatientData(
                //   model,
                //   title,
                //   controller.text,
                // );
              } else {
                // userProvider.updateSpecialistData(
                //   model,
                //   title,
                //   controller.text,
                // );
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showDeleteUserDialog(
    BuildContext context, BegginCubit userProvider) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Eliminar cuenta"),
        content: const Text("¿Estás seguro de que deseas eliminar tu cuenta?"),
        actions: <Widget>[
          AppButton.text(
            label: 'Cancelar',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          AppButton.destructive(
            label: 'Aceptar',
            onPressed: () async {
              await userProvider
                  .deletePatient(userProvider.state.patientModel!.id!);
            },
          ),
        ],
      );
    },
  );
}
