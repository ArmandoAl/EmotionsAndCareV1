import '../../../../demo/widgets/demo_svg.dart';
import '../../../../helpers/paths.dart';

class ItemsDetailScreen extends StatefulWidget {
  final String title;
  final List<UserAchievement> achivementItems;
  final Future<Null> Function(UserAchievement achivement) onAchivementTap;
  final List<StickerModel> stickersItems;
  final Future<Null> Function(StickerModel sticker) onStickerTap;
  final List<UserFlower> flowers;
  final Future<Null> Function(UserFlower flower) onFlowerTap;

  const ItemsDetailScreen({
    super.key,
    required this.title,
    required this.achivementItems,
    required this.onAchivementTap,
    required this.stickersItems,
    required this.onStickerTap,
    required this.flowers,
    required this.onFlowerTap,
  });

  @override
  State<ItemsDetailScreen> createState() => _ItemsDetailScreenState();
}

class _ItemsDetailScreenState extends State<ItemsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderWidget(
        title: widget.title,
        isForReturn: true,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        //scroll grid view
        child: buildGridView(
            widget.title,
            widget.achivementItems,
            widget.onAchivementTap,
            widget.stickersItems,
            widget.onStickerTap,
            widget.flowers,
            widget.onFlowerTap),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final VoidCallback onTap;

  const ItemCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          demoSvg(
            imagePath,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(description, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

Widget buildGridView(
  String title,
  List<UserAchievement> achivementItems,
  Future<Null> Function(UserAchievement achivement) onAchivementTap,
  List<StickerModel> stickersItems,
  Future<Null> Function(StickerModel sticker) onStickerTap,
  List<UserFlower> flowers,
  Future<Null> Function(UserFlower flower) onFlowerTap,
) {
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.8,
    ),
    itemCount: title == 'Logros'
        ? achivementItems.length
        : title == 'Stickers'
            ? stickersItems.length
            : flowers.length,
    itemBuilder: (context, index) {
      final item = title == 'Logros'
          ? achivementItems[index]
          : title == 'Stickers'
              ? stickersItems[index]
              : flowers[index];
      return ItemCard(
        onTap: () async {
          if (title == 'Logros') {
            await onAchivementTap(item as UserAchievement);
          } else if (title == 'Stickers') {
            await onStickerTap(item as StickerModel);
          } else {
            await onFlowerTap(item as UserFlower);
          }
        },
        imagePath: title == 'Logros'
            ? item is UserAchievement
                ? item.achievement!.imageUrl ?? ''
                : ''
            : title == 'Stickers'
                ? item is StickerModel
                    ? item.url ?? ''
                    : ''
                : item is UserFlower
                    ? item.flower.urls![item.state].url
                    : '',
        title: 'Title',
        description: 'Description',
      );
    },
  );
}
