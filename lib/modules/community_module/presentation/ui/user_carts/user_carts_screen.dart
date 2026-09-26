import '../../../../../helpers/paths.dart';

class UserCartsScreen extends StatefulWidget {
  final List<CartModel> carts;
  final int userId;
  final int index;
  final Function(int) updateIndex;
  const UserCartsScreen(
      {super.key,
      required this.carts,
      required this.index,
      required this.updateIndex,
      required this.userId});

  @override
  State<UserCartsScreen> createState() => _UserCartsScreenState();
}

class _UserCartsScreenState extends State<UserCartsScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Text("Buzón",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: AppColors.shadowWarm)),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buzonTab(context,
                  label: "Mis cartas",
                  selected: widget.index == 0,
                  onTap: () => widget.updateIndex(0)),
              _buzonTab(context,
                  label: "Enviadas",
                  selected: widget.index == 1,
                  onTap: () => widget.updateIndex(1)),
            ],
          ),
          const Divider(),
          const SizedBox(height: AppSpacing.xs),
          Expanded(
            child: widget.carts.isEmpty
                ? AppEmptyState(
                    icon: Icons.mail_outline_rounded,
                    title: widget.index == 1
                        ? 'Aún no has enviado cartas'
                        : 'Tu buzón está vacío',
                    message: widget.index == 1
                        ? 'Las cartas que envíes a la comunidad aparecerán aquí.'
                        : 'Cuando recibas cartas de la comunidad, aparecerán aquí.',
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: widget.carts.length,
                    itemBuilder: (context, index) {
                      return cartWidget(
                        context,
                        widget.carts[index],
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AnswerCartScreen(
                                cart: widget.carts[index],
                                userId: widget.userId,
                                letraEmisor: widget.carts[index].letraEmisor,
                                isFromBuzon: true,
                                itsFromAnotherUser: widget.index == 1,
                                onSend: () {
                                  return;
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}

Widget _buzonTab(
  BuildContext context, {
  required String label,
  required bool selected,
  required VoidCallback onTap,
}) {
  final ColorScheme scheme = Theme.of(context).colorScheme;
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(AppRadius.sm),
    child: Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: selected
                      ? scheme.secondary
                      : AppColors.shadowWarm.withOpacity(0.45),
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          if (selected)
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: scheme.secondary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    ),
  );
}

Widget responseWidgetContainer(
    BuildContext context, String letra, String content, int index) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.85,
    height: MediaQuery.of(context).size.height * 0.6,
    decoration: BoxDecoration(
      image: DecorationImage(
        colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.secondary.withOpacity(0.99),
            BlendMode.src),
        image: const AssetImage(Assets.cartPaper),
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(30),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 5,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        Expanded(
            child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05),
          child: SingleChildScrollView(
            child: Text(
              content,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.018,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        )),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        Row(
          children: [
            //sticker
            const Spacer(),
            Text(
              "- $letra",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.02,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.03),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
      ],
    ),
  );
}


//  return Column(
//                   children: [
//                     SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: MediaQuery.of(context).size.width * 0.07),
//                       child: cartWidget(
//                         context,
//                         widget.carts[index],
//                       ),
//                     ),
//                     SizedBox(height: MediaQuery.of(context).size.height * 0.01),
//                     Expanded(
//                       child: PageView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: widget.index == 0
//                             ? widget.carts[index].respuestas!.length
//                             //el intemCount sera de el numero de respuestas que tiene la carta y que el idReceptor sea el id del usuario
//                             : widget.carts[index].respuestas!
//                                 .where((element) =>
//                                     element.idReceptor == widget.userId)
//                                 .length,
//                         itemBuilder: (context, indexResponse) {
//                           return Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal:
//                                     MediaQuery.of(context).size.width * 0.08),
//                             child: responseWidgetContainer(
//                                 context,
//                                 widget.index == 0
//                                     ? widget
//                                         .carts[index]
//                                         .respuestas![indexResponse]
//                                         .letraReceptor
//                                     : widget.carts[index].respuestas!
//                                         .where((element) =>
//                                             element.idReceptor == widget.userId)
//                                         .toList()[indexResponse]
//                                         .letraReceptor,
//                                 widget.index == 0
//                                     ? widget.carts[index]
//                                         .respuestas![indexResponse].contenido
//                                     : widget.carts[index].respuestas!
//                                         .where((element) =>
//                                             element.idReceptor == widget.userId)
//                                         .toList()[indexResponse]
//                                         .contenido,
//                                 widget.index),
//                           );
//                         },
//                       ),