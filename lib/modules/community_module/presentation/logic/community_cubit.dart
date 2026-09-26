import '../../../../helpers/paths.dart';

class CommunityCubit extends Cubit<CommunityState> {
  final ICartRepository repository;

  CommunityCubit({
    required this.repository,
  }) : super(const CommunityState());

  Future<void> initCommunity(int userId) async {
    emit(state.copyWith(status: CommunityStatus.loading));
    try {
      final cartList = await repository.initCommunity(userId);

      emit(state.copyWith(
        cartFromCommunity: cartList,
        status: CommunityStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(status: CommunityStatus.error));
    }
  }

  Future<void> getCartFromUser(int userId, bool isPatient) async {
    emit(state.copyWith(status: CommunityStatus.loading));
    try {
      final cartList = await repository.getCartList(userId, isPatient);
      emit(state.copyWith(
        cartFromUser: cartList,
        status: CommunityStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(status: CommunityStatus.error));
    }
  }

  Future<CartWithAchivement> addCart(
      CartModel cart, int idUser, bool isPatient) async {
    emit(state.copyWith(status: CommunityStatus.loading));
    try {
      CartWithAchivement result =
          await repository.addCart(cart, idUser, isPatient);

      //encuentra la carta en la lista de cartas de la del usuario
      if (result.id != 0) {
        cart = cart.copyWith(id: result.id);
        emit(state.copyWith(
            cartFromUser: [...state.cartFromUser, cart],
            status: CommunityStatus.success));

        return result;
      }

      emit(state.copyWith(status: CommunityStatus.error));
      throw Exception('Failed to add note');
    } catch (e) {
      emit(state.copyWith(status: CommunityStatus.error));
      throw Exception('Failed to add note');
    }
  }

  Future<ResponseWithAchivement> addResponse(CartResponse cartResponse,
      int idCart, bool isPatient, int idPatient) async {
    emit(state.copyWith(status: CommunityStatus.loading));
    try {
      ResponseWithAchivement result =
          await repository.addResponse(cartResponse, idCart);

      emit(state.copyWith(
          cartFromCommunity: state.cartFromCommunity
              .where((element) => element.id != idCart)
              .toList(),
          status: CommunityStatus.success));

      return result;
    } catch (e) {
      emit(state.copyWith(status: CommunityStatus.error));
      throw Exception('Failed to add note');
    }
  }

  void clean() {
    emit(const CommunityState());
  }
}

bool haveAnswersInMyInbox(CommunityState state, int userId) {
  //busca si el user id existe en alguna respuesta de la comunidad, cualquier carta que tenga una respuesta con el id del usuario retorna true
  return state.cartFromCommunity.any((element) =>
      element.respuestas.any((response) => response.idReceptor == userId));
}
