import '../../../../helpers/paths.dart';

class RegisterProcessScreen extends StatefulWidget {
  final Future<void> Function(
          PatientModel patient, PageController pageController, bool remember)?
      onPatientRegister;
  final Future<void> Function(SpecialistModel specialist,
      PageController pageController, bool remember)? onSpecialistrRegister;
  const RegisterProcessScreen(
      {super.key, this.onPatientRegister, this.onSpecialistrRegister});

  @override
  State<RegisterProcessScreen> createState() => _RegisterProcessScreenState();
}

class _RegisterProcessScreenState extends State<RegisterProcessScreen> {
  TermsRepository termsRepository = TermsRepository();
  PageController pageController = PageController();
  bool? isPatient;
  bool? oscureText = true;
  String? termsText;
  String sex = "Masculino";
  bool isLoaing = false;
  DateTime? bornDate;
  bool isRemember = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController licenseController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  List<DropdownMenuItem<String>>? items = [
    const DropdownMenuItem(
      value: "Cognitivo-Conductual",
      child: Text("Cognitivo-Conductual"),
    ),
    const DropdownMenuItem(
      value: "Psicoanálisis",
      child: Text("Psicoanálisis"),
    ),
    const DropdownMenuItem(
      value: "Humanista",
      child: Text("Humanista"),
    ),
    const DropdownMenuItem(
      value: "Sistémico",
      child: Text("Sistémico"),
    ),
    const DropdownMenuItem(
      value: "Neuropsicológico",
      child: Text("Neuropsicológico"),
    ),
    const DropdownMenuItem(
      value: "Gestalt",
      child: Text("Gestalt"),
    ),
    const DropdownMenuItem(
      value: "Sexología",
      child: Text("Sexología"),
    ),
  ];
  String? selectedItem = "Cognitivo-Conductual";

  TextEditingController institutionController = TextEditingController();
  TextEditingController ubicationController = TextEditingController();

  void setIsPatient(bool isPatient) async {
    if (isPatient) {
      termsRepository.getTerms(1).then((value) {
        setState(() {
          termsText = value;
        });
      });
    } else {
      termsRepository.getTerms(2).then((value) {
        setState(() {
          termsText = value;
        });
      });
    }

    setState(() {
      this.isPatient = isPatient;
    });
  }

  void setRemember(bool remember) {
    setState(() {
      isRemember = remember;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    licenseController.dispose();
    ageController.dispose();
    institutionController.dispose();
    ubicationController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BegginCubit userProvider = getIt<BegginCubit>();
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.dayBackground,
      ),
      child: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        itemCount: 4,
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return choiseUserType(context, pageController, isPatient,
                  (bool isPatient) async {
                setIsPatient(isPatient);
              });
            case 1:
              return terms(context, pageController, isPatient!, termsText);
            case 2:
              return registerForm(
                  context,
                  pageController,
                  isPatient!,
                  nameController,
                  emailController,
                  passwordController,
                  confirmPasswordController,
                  phoneController,
                  ageController,
                  institutionController,
                  ubicationController,
                  items,
                  selectedItem!,
                  (String value) {
                    setState(() {
                      selectedItem = value;
                    });
                  },
                  sex,
                  (String value) {
                    setState(() {
                      sex = value;
                    });
                  },
                  licenseController,
                  (PatientModel patient) async {
                    await widget.onPatientRegister!(
                        patient, pageController, isRemember);
                  },
                  (SpecialistModel specialist) async {
                    await widget.onSpecialistrRegister!(
                        specialist, pageController, isRemember);
                  },
                  oscureText,
                  () {
                    setState(() {
                      oscureText = !oscureText!;
                    });
                  },
                  isLoaing,
                  () {
                    setState(() {
                      isLoaing = !isLoaing;
                    });
                  },
                  bornDate,
                  (DateTime value) {
                    setState(() {
                      bornDate = value;
                    });
                  },
                  isRemember,
                  setRemember);
            case 3:
              return welcomeMessage(
                  context,
                  isPatient,
                  emailController.text.trim(),
                  passwordController.text.trim(),
                  userProvider);
            default:
              return Container();
          }
        },
      ),
    );
  }
}

Widget welcomeMessage(
  BuildContext context,
  bool? isPatient,
  String email,
  String password,
  BegginCubit userProvider,
) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    color: AppColors.dayBackground,
    padding: const EdgeInsets.all(AppSpacing.lg),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            "Te damos la bienvenida a Emotions&Care. ¡Disfruta y crece con nosotros!",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(color: AppColors.shadowWarm)),
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        AppButton(
          label: 'Continuar',
          onPressed: () async {
            await userProvider.multiLogin(email, password);
            if (context.mounted) Navigator.pop(context);
            if (context.mounted) Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

Widget registerForm(
  BuildContext context,
  PageController pageController,
  bool isPatient,
  TextEditingController nameController,
  TextEditingController emailController,
  TextEditingController passwordController,
  TextEditingController confirmPasswordController,
  TextEditingController phoneController,
  TextEditingController ageController,
  TextEditingController institutionController,
  TextEditingController ubicationController,
  List<DropdownMenuItem<String>>? items,
  String selectedItem,
  Function(String value) setSelectedItem,
  String sex,
  Function changeSex,
  TextEditingController? licenseController,
  Future<void> Function(PatientModel patient) onPatientRegister,
  Future<void> Function(SpecialistModel specialist) onSpecialistrRegister,
  bool? oscureText,
  void Function()? changeObscureText,
  bool isLoaing,
  void Function() setState,
  DateTime? bornDate,
  Function changeBornDate,
  bool isRemember,
  void Function(bool remember) setRemember,
) {
  return Scaffold(
    backgroundColor: AppColors.dayBackground,
    body: Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    pageController.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  },
                  icon: const Icon(Icons.arrow_back_rounded, size: 22),
                ),
                const Spacer()
              ],
            ),
            Text(
              "¡Listo para empezar!",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: AppColors.shadowWarm),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              "Por favor, rellena los siguientes campos, para acceder a nuestros servicios.",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.shadowWarm.withOpacity(0.7)),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            _customTextFieldForRegister(context, nameController, "Nombre",
                Icons.person, null, null, TextInputType.text),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            _customTextFieldForRegister(context, emailController, "Correo",
                Icons.email, null, null, TextInputType.emailAddress),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            isPatient
                ? _customDataOfBornWiget(
                    context,
                    "Fecha de nacimiento",
                    Icons.calendar_today,
                    null,
                    null,
                    TextInputType.datetime,
                    bornDate, (DateTime value) {
                    changeBornDate(value);
                  })
                : _customTextFieldForRegister(context, ageController, "Edad",
                    Icons.person, null, null, TextInputType.number),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            _genderCuestomDropDown(
                context, sex, "Genero", Icons.person, changeSex),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            _customTextFieldForRegister(context, phoneController, "Teléfono",
                Icons.phone, null, null, TextInputType.phone),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            if (!isPatient)
              _customTextFieldForRegister(
                  context,
                  licenseController!,
                  "Cédula profesional",
                  Icons.credit_card,
                  null,
                  null,
                  TextInputType.text),
            if (!isPatient)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
            if (!isPatient)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.daySurfaceSunken,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: DropdownButton(
                    isExpanded: true,
                    value: selectedItem,
                    underline: const SizedBox.shrink(),
                    items: items,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                    ),
                    onChanged: (String? value) {
                      setSelectedItem(value!);
                    }),
              ),
            if (!isPatient)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
            if (!isPatient)
              _customTextFieldForRegister(
                  context,
                  ubicationController,
                  "Ubicación (Opcional)",
                  Icons.credit_card,
                  null,
                  null,
                  TextInputType.text),
            if (!isPatient)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
            _customTextFieldForRegister(
              context,
              passwordController,
              "Contraseña",
              Icons.lock,
              oscureText,
              changeObscureText,
              TextInputType.text,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            _customTextFieldForRegister(
              context,
              confirmPasswordController,
              "Confirmar contraseña",
              Icons.lock,
              oscureText,
              null,
              TextInputType.text,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Row(
              children: [
                Checkbox(
                    value: isRemember,
                    onChanged: (value) {
                      setRemember(value!);
                    }),
                Text(
                  "Recordar mis datos",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: AppColors.shadowWarm),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                isLoading: isLoaing,
                label: "Registrarse",
                onPressed: () async {
                  if (nameController.text.isEmpty ||
                      emailController.text.isEmpty ||
                      passwordController.text.isEmpty ||
                      phoneController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor, rellena todos los campos'),
                      ),
                    );
                    return;
                  }

                  if (isPatient && bornDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Por favor, selecciona tu fecha de nacimiento'),
                      ),
                    );
                    return;
                  }

                  if (passwordController.text !=
                      confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Las contraseñas no coinciden'),
                      ),
                    );
                    return;
                  }

                  if (isPatient == false) {
                    if (licenseController!.text.isEmpty ||
                        ageController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Por favor, rellena todos los campos de especialista'),
                        ),
                      );
                      return;
                    }
                  }

                  //validar numero y correo
                  if (!RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                      .hasMatch(emailController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Correo no valido'),
                      ),
                    );
                    return;
                  }

                  if (!RegExp(r'^[0-9]{10}$').hasMatch(phoneController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Telefono no valido'),
                      ),
                    );
                    return;
                  }

                  setState();

                  if (isPatient) {
                    await onPatientRegister(PatientModel(
                      id: 0,
                      name: nameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                      phone: phoneController.text,
                      sex: sex,
                      termsClass: TermAndConditions(
                        id: 1,
                        terms: "Términos y condiciones",
                      ),
                      type: UserType.patient,
                      specialist: null,
                      token:
                          'jknbvibnrwevruibweqig4wufinj6hrveuheic4buwn4ivh2ug54ifwhvn6g354c8rytaejke7jrhaeg456k7el8kt7jrsteahrgef${passwordController.text}',
                      tokenForRelate: '',
                      settings: null,
                      bornDate: bornDate!,
                    ));
                  } else {
                    await onSpecialistrRegister(SpecialistModel(
                      id: 0,
                      professionalLicense: licenseController!.text,
                      patients: [],
                      name: nameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                      phone: phoneController.text,
                      sex: sex,
                      age: int.parse(ageController.text),
                      termsClass: TermAndConditions(
                        id: 2,
                        terms: "Términos y condiciones",
                      ),
                      type: UserType.specialist,
                      token:
                          'jknbvibnrwevruibweqig4wufinj6hrveuheic4buwn4ivh2ug54ifwhvn6g354c8rytaejke7jrhaeg456k7el8kt7jrsteahrgef${passwordController.text}',
                      tokenForRelate: '',
                      bornDate: DateTime.now().toLocal(),
                      focus: selectedItem,
                      institution: institutionController.text,
                      ubication: ubicationController.text,
                    ));
                  }

                  setState();
                },
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
        ),
      ),
    ),
  );
}

Widget _customTextFieldForRegister(
  BuildContext context,
  TextEditingController controller,
  String hintText,
  IconData icon,
  bool? obscureText, // Cambiado de bool? a bool
  void Function()? changeObscureText,
  TextInputType type,
) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    child: Column(
      children: [
        Row(
          children: [
            Text(
              hintText,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: AppColors.shadowWarm),
            ),
            Text(
              "*",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
            const Spacer()
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: type,
                obscureText:
                    obscureText ?? false, // Verificar si obscureText es nulo
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.shadowWarm),
                decoration: InputDecoration(
                  hintText: hintText,
                  prefixIcon: Icon(icon),
                  //border just in the bottom,
                  border: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.shadowWarm.withOpacity(0.3)),
                  ),
                ),
              ),
            ),
            if (changeObscureText != null)
              IconButton(
                onPressed: changeObscureText,
                icon: Icon(
                  obscureText!
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                ),
              ),
          ],
        ),
      ],
    ),
  );
}

Widget terms(
  BuildContext context,
  PageController pageController,
  bool isPatient,
  String? termsText,
) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    padding: const EdgeInsets.all(AppSpacing.lg),
    color: AppColors.dayBackground,
    child: Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        Text(
          "Términos y condiciones",
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: ListView(
              children: [
                Text(
                  termsText != null ? termsText.replaceAll("|", "\n") : "",
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.shadowWarm.withOpacity(0.8),
                      ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: AppButton(
                  label: "Aceptar",
                  onPressed: () {
                    pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
                child: AppButton.text(
                  label: "Rechazar",
                  onPressed: () {
                    pageController.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        )
      ],
    ),
  );
}

Widget choiseUserType(
  BuildContext context,
  PageController pageController,
  bool? isPatient,
  Future<void> Function(bool isPatient) onChoise,
) {
  return Scaffold(
    backgroundColor: AppColors.dayBackground,
    body: Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_rounded, size: 28),
              ),
              const Spacer()
            ],
          ),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.sm),
                Text("¡Hay que comenzar!",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: AppColors.shadowWarm)),
                const SizedBox(height: AppSpacing.xl),
                Text("¿Eres un joven universitario/a, o un especialista?",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.shadowWarm.withOpacity(0.7),
                        )),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await onChoise(true);
                        },
                        child: Image.asset(
                          isPatient != null && isPatient
                              ? Assets.pacienteHoverIcon
                              : Assets.pacienteIcon,
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await onChoise(false);
                        },
                        child: Image.asset(
                            isPatient != null && isPatient == false
                                ? Assets.specialistHoverIcon
                                : Assets.specialistIcon),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        if (isPatient != null) {
          pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Por favor, elige un tipo de usuario'),
            ),
          );
        }
      },
      child: const Icon(Icons.arrow_forward_rounded),
    ),
  );
}

Widget _genderCuestomDropDown(
  BuildContext context,
  String sex,
  String title,
  IconData icon,
  Function changeSex,
) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    decoration: BoxDecoration(
      color: AppColors.daySurfaceSunken,
      borderRadius: BorderRadius.circular(AppRadius.md),
    ),
    child: DropdownButton<String>(
      value: sex,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      iconSize: 24,
      elevation: 16,
      underline: const SizedBox.shrink(),
      onChanged: (String? newValue) {
        changeSex(newValue!);
      },
      items: <String>['Masculino', 'Femenino', 'Otro']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ),
  );
}

Widget _customDataOfBornWiget(
  BuildContext context,
  String hintText,
  IconData icon,
  bool? obscureText, // Cambiado de bool? a bool
  void Function()? changeObscureText,
  TextInputType type,
  DateTime? bornDate,
  Function changeBornDate,
) {
  //this widget is for the date of born, it has to be a date picker widget for the day, month and year
  return GestureDetector(
    onTap: () async {
      final DateTime? picked = await showDatePicker(
        initialEntryMode: DatePickerEntryMode.input,
        helpText: "Selecciona tu fecha de nacimiento",
        cancelText: "Cancelar",
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1924),
        lastDate: DateTime.now(),
      );
      if (picked != null) {
        changeBornDate(picked);
      }
    },
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                hintText,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: AppColors.shadowWarm),
              ),
              Text(
                "*",
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.daySurfaceSunken,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    bornDate != null
                        ? "${bornDate.day}/${bornDate.month}/${bornDate.year}"
                        : "Selecciona tu fecha de nacimiento",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: AppColors.shadowWarm),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
