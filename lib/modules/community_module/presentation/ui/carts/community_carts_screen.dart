import 'package:card_swiper/card_swiper.dart';
import '../../../../../helpers/paths.dart';

class CommunityCartsScreen extends StatefulWidget {
  final List<CartModel> carts;
  final void Function(CartModel) onCartTap;
  const CommunityCartsScreen(
      {super.key, required this.onCartTap, required this.carts});

  @override
  State<CommunityCartsScreen> createState() => _CommunityCartsScreenState();
}

class _CommunityCartsScreenState extends State<CommunityCartsScreen> {
  final SwiperController controller = SwiperController();

  void moveToNextCard() {
    controller.previous();
  }

  void moveToPreviousCard() {
    controller.next();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.carts.isEmpty) {
      return const AppEmptyState(
        icon: Icons.mail_outline_rounded,
        title: 'Todavía no hay cartas',
        message: 'Cuando la comunidad comparta cartas de apoyo, aparecerán aquí.',
      );
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.055),
          Swiper(
            onTap: (index) {
              widget.onCartTap(widget.carts[index]);
            },
            itemCount: widget.carts.length,
            itemWidth: MediaQuery.of(context).size.width * 0.8,
            itemHeight: MediaQuery.of(context).size.height * 0.6,
            scale: 0.9,
            layout: SwiperLayout.STACK,
            curve: Curves.easeInOut,
            controller: controller,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Theme.of(context)
                            .colorScheme
                            .onPrimaryContainer
                            .withOpacity(0.99),
                        BlendMode.src),
                    image: const AssetImage(
                      Assets.cartPaper,
                    ),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: AppShadows.card,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.sm),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: SingleChildScrollView(
                          child: Text(
                            widget.carts[index].contenido,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: AppColors.shadowWarm),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(width: AppSpacing.lg),
                        Text(
                          "${widget.carts[index].respuestas.length} respuestas",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.shadowWarm.withOpacity(0.7)),
                        ),
                        const Spacer(),
                        Text(
                          "- ${widget.carts[index].letraEmisor}",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: AppColors.shadowWarm),
                        ),
                        const SizedBox(width: AppSpacing.xl),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              );
            },
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: moveToPreviousCard,
                icon: const Icon(Icons.arrow_back_ios_rounded, size: 22),
                color: AppColors.shadowWarm,
              ),
              Text(
                "Navegar",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: AppColors.shadowWarm),
              ),
              IconButton(
                onPressed: moveToNextCard,
                icon: const Icon(Icons.arrow_forward_ios_rounded, size: 22),
                color: AppColors.shadowWarm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
