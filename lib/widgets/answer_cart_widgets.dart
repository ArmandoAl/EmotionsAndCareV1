import '../demo/widgets/demo_svg.dart';

import '../helpers/paths.dart';

Widget cartWidget(BuildContext context, CartModel cart, {Function()? onTap}) {
  return GestureDetector(
    onTap: () async {
      if (onTap != null) {
        onTap();
      } else {
        await showCartDialog(context, cart);
      }
    },
    child: Container(
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "${cart.fechaCreacion!.day}/${cart.fechaCreacion!.month}/${cart.fechaCreacion!.year}",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.018,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  cart.contenido,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.018,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  "- ${cart.letraEmisor}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
                const Spacer(),
                Text(
                  "${cart.respuestas.length} respuestas",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.018,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    ),
  );
}

Widget responseWidget(
  BuildContext context,
  String letra,
  TextEditingController controller,
  String? content,
  String hintText, {
  bool sticker = true,
  StickerModel? stickerModel,
  Function()? onStickerPressed,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.onSecondaryContainer,
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
        Expanded(
            child: content == null
                ? TextField(
                    controller: controller,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(20),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      content,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.018,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  )),
        SizedBox(height: MediaQuery.of(context).size.height * 0.001),
        Row(
          children: [
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            stickerModel != null
                ? IconButton(
                    onPressed: onStickerPressed,
                    icon: demoSvg(
                      stickerModel.url ?? "",
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                  )
                : sticker
                    ? IconButton(
                        onPressed: () {
                          onStickerPressed!();
                        },
                        icon: const Icon(Icons.sticky_note_2_rounded))
                    : Container(),
            const Spacer(),
            Text(
              letra,
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
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
      ],
    ),
  );
}

Future<void> showCartDialog(BuildContext context, CartModel cart) async {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Text(
                      cart.contenido,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.018,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  const Spacer(),
                  Text(
                    "- ${cart.letraEmisor}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.08),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            ],
          ),
        ),
      );
    },
  );
}
