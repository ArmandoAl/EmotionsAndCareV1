import '../demo/widgets/demo_svg.dart';
import '../helpers/paths.dart';

class StickerWidget extends StatefulWidget {
  final StickerModel? sticker;
  final AnimationController? controller;
  final Animation<double>? animation;
  final UICubit uiProvider;
  final UIState uiState;
  final int index;
  final bool customEnable;

  const StickerWidget({
    super.key,
    required this.sticker,
    required this.controller,
    required this.animation,
    required this.uiProvider,
    required this.uiState,
    required this.index,
    required this.customEnable,
  });

  @override
  State<StickerWidget> createState() => _StickerWidgetState();
}

class _StickerWidgetState extends State<StickerWidget>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: -10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: 0), weight: 1),
    ]).animate(
        CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _triggerShake() {
    _shakeController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width * 0.175;

    Widget content = widget.sticker != null
        ? demoSvg(
            widget.sticker!.url!,
            fit: BoxFit.contain,
          )
        : widget.customEnable
            ? Container(
                width: size * 0.3,
                height: size * 0.3,
                margin: EdgeInsets.symmetric(vertical: size * 0.3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.35),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(1, 3),
                    ),
                  ],
                ),
              )
            : const SizedBox();

    if (widget.customEnable) {
      return GestureDetector(
        onTap: () async {
          await showItemsDialog(
            context,
            "Tus stickers",
            widget.index,
            widget.uiProvider,
            widget.uiState,
            isEmply: widget.sticker == null,
          );
        },
        child: AnimatedBuilder(
          animation: widget.controller!,
          builder: (context, child) {
            return Transform.scale(
              scale: widget.animation!.value,
              child: SizedBox(width: size, height: size, child: content),
            );
          },
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          _triggerShake();
        },
        child: AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakeAnimation.value, 0),
              child: SizedBox(width: size, height: size, child: content),
            );
          },
        ),
      );
    }
  }
}
