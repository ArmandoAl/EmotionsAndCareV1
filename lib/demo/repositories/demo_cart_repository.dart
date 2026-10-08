import '../../helpers/paths.dart';
import '../demo_data_store.dart';

/// Reemplazo en memoria de [ICartRepository] (módulo Comunidad) para el modo
/// demo.
class DemoCartRepository implements ICartRepository {
  static bool _firstResponseGiven = false;

  @override
  Future<CartWithAchivement> addCart(
      CartModel cart, int idUser, bool isPatient) async {
    final bool isFirstTime = DemoDataStore.myCarts.isEmpty;
    final int id = DemoDataStore.nextCartId;
    DemoDataStore.myCarts.insert(0, cart.copyWith(id: id));

    return CartWithAchivement(
      id: id,
      achivementId: isFirstTime ? 1 : null,
    );
  }

  @override
  Future<bool> deleteCart(int idCart) async {
    DemoDataStore.myCarts.removeWhere((element) => element.id == idCart);
    DemoDataStore.communityInbox.removeWhere((element) => element.id == idCart);
    return true;
  }

  @override
  Future<bool> updateCart(CartModel cart) async {
    final int index = DemoDataStore.myCarts.indexWhere((e) => e.id == cart.id);
    if (index != -1) {
      DemoDataStore.myCarts[index] = cart;
    }
    return true;
  }

  @override
  Future<List<CartModel>> getCartList(int idUser, bool isPatient) async {
    return List<CartModel>.from(DemoDataStore.myCarts);
  }

  @override
  Future<CartModel> getCart(int idCart) async {
    return [...DemoDataStore.myCarts, ...DemoDataStore.communityInbox]
        .firstWhere((element) => element.id == idCart);
  }

  @override
  Future<ResponseWithAchivement> addResponse(
      CartResponse cartResponse, int idCart) async {
    DemoDataStore.communityInbox.removeWhere((element) => element.id == idCart);

    final bool isFirstTime = !_firstResponseGiven;
    _firstResponseGiven = true;

    return ResponseWithAchivement(
      id: DemoDataStore.nextCartId,
      achivementId: isFirstTime ? 2 : null,
    );
  }

  @override
  Future<List<CartModel>> initCommunity(int userId) async {
    return List<CartModel>.from(DemoDataStore.communityInbox);
  }
}
