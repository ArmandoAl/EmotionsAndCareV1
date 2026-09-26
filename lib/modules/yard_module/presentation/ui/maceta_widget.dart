import 'dart:async';

import '../../../../demo/widgets/demo_svg.dart';
import '../../../../helpers/paths.dart';
import '../../../auth_module/domain/progress.dart';

class PotWidget extends StatefulWidget {
  final bool customEnable;
  final Function(bool value) dimissPlane;
  final UICubit cubit;
  final UIState state;
  const PotWidget({
    super.key,
    required this.customEnable,
    required this.dimissPlane,
    required this.cubit,
    required this.state,
  });

  @override
  State<PotWidget> createState() => _PotWidgetState();
}

class _PotWidgetState extends State<PotWidget> with TickerProviderStateMixin {
  late BegginCubit userProvider;
  late AnimationController _controller;
  late Animation<double> _containerHeightAnimation;
  late Animation<double> _offsetAnimation;

  AnimationController? _stickersController;
  Animation<double>? _stickersAnimation;
  AnimationController? _animationController;
  Animation? _animation;
  double startHeight = 250;
  double endHeight = 550;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    userProvider = getIt<BegginCubit>();

    if (mounted) {
      if (widget.customEnable) {
        _stickersController = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 500),
        )..repeat(reverse: true);
        // Configurar la animación de los stickers
        _stickersAnimation = Tween<double>(
          begin: 1.0,
          end:
              1.1, // Cambia este valor a lo que desees (un poco más grande que 1.0)
        ).animate(
          CurvedAnimation(
            parent: _stickersController!,
            curve: Curves.easeInOut,
          ),
        )..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _stickersController!.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _stickersController!.forward();
            }
          });

        _animationController = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 2000),
        )..repeat(reverse: true);

        _animation = ColorTween(
          begin: const Color.fromARGB(255, 255, 255, 255),
          end: const Color.fromARGB(255, 87, 87, 83),
        ).animate(_animationController!);
      }

      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      );

      _containerHeightAnimation = Tween<double>(
        begin: startHeight,
        end: endHeight,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));

      _offsetAnimation = Tween<double>(
        begin: 0,
        end: 275,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
    }
  }

  void animateUp() {
    if (!_controller.isAnimating && !_controller.isCompleted) {
      _controller.forward();
    }
  }

  void changeHeightTap() {
    if (!widget.customEnable) {
      if (isExpanded) {
        widget.dimissPlane(false);
        _controller.reverse();
        Timer(
          const Duration(milliseconds: 500),
          () {
            setState(() {
              isExpanded = false;
            });
          },
        );
      } else {
        animateUp();
        Timer(
          const Duration(milliseconds: 500),
          () {
            setState(() {
              isExpanded = true;
            });
          },
        );
        widget.dimissPlane(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final plantPotData = calculatePlantAndPotPosition(screenSize);
        final double offsetY = _offsetAnimation.value;

        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.transparent,
          child: Stack(
            children: [
              // Green background animated container
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: screenSize.width,
                  height: _containerHeightAnimation.value,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage(Assets.wood),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(75),
                      topRight: Radius.circular(75),
                    ),
                    border: const Border(
                      top: BorderSide(color: Colors.black, width: 3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        blurRadius: 3,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),

              // Tap Detector
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: screenSize.width,
                  height: screenSize.height,
                  color: Colors.transparent,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (widget.state.currentFlower != null)
                        Positioned(
                          bottom: (plantPotData['plantBottom'] ?? 0) + offsetY,
                          child: InkWell(
                            onTap: () {
                              if (widget.customEnable) {
                                showItemsDialog(context, "Tus plantas", 0,
                                    widget.cubit, widget.state);
                              } else {
                                changeHeightTap();
                              }
                            },
                            child: demoSvg(
                              widget.state.currentFlower!.flower
                                  .urls![widget.state.currentFlower!.state].url,
                              width: plantPotData['plantSize'],
                              height: plantPotData['plantSize'],
                              placeholderBuilder: (context) =>
                                  const CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      if (isExpanded)
                        Positioned(
                            bottom:
                                offsetY - (plantPotData['potSize'] ?? 0) - 25,
                            child: SizedBox(
                                child: ObjetivesWidget(
                                    stage: StageProgress(
                                        stageNumber:
                                            widget.state.currentFlower!.state,
                                        progressInfos:
                                            widget.state.flowerProgress)))),
                      Positioned(
                        bottom: (plantPotData['potBottom'] ?? 0) + offsetY,
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(),
                          child: widget.customEnable &&
                                  _animationController != null
                              ? InkWell(
                                  onTap: () async {
                                    if (widget.customEnable) {
                                      await showItemsDialog(
                                          context,
                                          "Tus plantas",
                                          0,
                                          widget.cubit,
                                          widget.state);
                                    } else {
                                      changeHeightTap();
                                    }
                                  },
                                  child: AnimatedBuilder(
                                    animation: _animationController!,
                                    builder: (context, child) {
                                      return demoSvg(
                                        Assets.potSvgAssets,
                                        height: plantPotData['potSize'],
                                        fit: BoxFit.fill,
                                        color: _animation!.value,
                                      );
                                    },
                                  ),
                                )
                              : InkWell(
                                  onTap: () async {
                                    if (widget.customEnable) {
                                      await showItemsDialog(
                                          context,
                                          "Tus plantas",
                                          0,
                                          widget.cubit,
                                          widget.state);
                                    } else {
                                      changeHeightTap();
                                    }
                                  },
                                  child: demoSvg(
                                    Assets.potSvgAssets,
                                    height: plantPotData['potSize'],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                        ),
                      ),
                      if (!isExpanded)
                        Positioned(
                          bottom: MediaQuery.of(context).size.height * 0.125,
                          left: MediaQuery.of(context).size.width * 0.075,
                          child: StickerWidget(
                              sticker: getStickerFromState(widget.state, 0),
                              controller: _animationController,
                              animation: _stickersAnimation,
                              uiProvider: widget.cubit,
                              uiState: widget.state,
                              index: 0,
                              customEnable: widget.customEnable),
                        ),
                      if (!isExpanded)
                        Positioned(
                          bottom: MediaQuery.of(context).size.height * 0.025,
                          left: MediaQuery.of(context).size.width * 0.3,
                          child: StickerWidget(
                              sticker: getStickerFromState(widget.state, 1),
                              controller: _animationController,
                              animation: _stickersAnimation,
                              uiProvider: widget.cubit,
                              uiState: widget.state,
                              index: 1,
                              customEnable: widget.customEnable),
                        ),
                      if (!isExpanded)
                        Positioned(
                          bottom: MediaQuery.of(context).size.height * 0.05,
                          right: MediaQuery.of(context).size.width * 0.2,
                          child: StickerWidget(
                              sticker: getStickerFromState(widget.state, 2),
                              controller: _animationController,
                              animation: _stickersAnimation,
                              uiProvider: widget.cubit,
                              uiState: widget.state,
                              index: 2,
                              customEnable: widget.customEnable),
                        ),
                      if (!isExpanded)
                        Positioned(
                          bottom: MediaQuery.of(context).size.height * 0.15,
                          right: MediaQuery.of(context).size.width * 0.075,
                          child: StickerWidget(
                              sticker: getStickerFromState(widget.state, 3),
                              controller: _animationController,
                              animation: _stickersAnimation,
                              uiProvider: widget.cubit,
                              uiState: widget.state,
                              index: 3,
                              customEnable: widget.customEnable),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _stickersController?.dispose();
    _animationController?.dispose();
    super.dispose();
  }
}

class ObjetivesWidget extends StatelessWidget {
  final StageProgress stage;
  const ObjetivesWidget({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Fase ${stage.stageNumber + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        ...stage.progressInfos.map(
          (item) {
            final progress = item.currentValue > item.targetValue
                ? item.targetValue
                : item.currentValue;

            return buildObjetiveItem(
              context,
              icon:
                  item.isCompleted ? Icons.check_circle : Icons.circle_outlined,
              iconColor: Colors.white,
              backgroundColor: item.isCompleted ? Colors.green : Colors.grey,
              text: item.description,
              progress: progress,
              showProgress: true,
              maxProgress: item.targetValue,
            );
          },
        ),
      ],
    );
  }
}

Widget buildObjetiveItem(
  BuildContext context, {
  required IconData icon,
  required Color iconColor,
  required Color backgroundColor,
  required String text,
  int progress = 0,
  int maxProgress = 1,
  bool showProgress = false,
}) {
  final width = MediaQuery.of(context).size.width * 0.6;

  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.8,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 35),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '$progress/$maxProgress',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (showProgress)
            SizedBox(
              width: width,
              child: LinearProgressIndicator(
                value: progress / maxProgress,
                backgroundColor: Colors.grey,
                color: Colors.white,
                minHeight: 10,
              ),
            ),
        ],
      ),
    ),
  );
}
