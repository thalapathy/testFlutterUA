import 'package:bloc/bloc.dart';

import '../repository/cart_repository.dart';

class CartState {
  final List<String> cartItems;

  const CartState(this.cartItems);

  factory CartState.initial() => CartState([]);
}

abstract class CartEvent {}

class AddToCartEvent extends CartEvent {
  final String ref;

  AddToCartEvent(this.ref);
}

class RemoveFromCartEvent extends CartEvent {
  final String ref;

  RemoveFromCartEvent(this.ref);
}

class ClearCartEvent extends CartEvent {}

class CartCubit extends Cubit<CartState> {
  final CartRepository _cartRepository = CartRepository();

  CartCubit() : super(CartState.initial()) {
    getCartItemsFromSharedPreferences();
  }

   void getCartItemsFromSharedPreferences() async {
    final cartItems = await _cartRepository.getCartItems();
    emit(CartState(cartItems));
  }

  void addToCart(String ref) async {
    await _cartRepository.addToCart(ref);
    final cartItems = await _cartRepository.getCartItems();
    emit(CartState(cartItems));
  }

  Future<void> removeFromCart(String ref) async {
    _cartRepository.removeFromCart(ref);
    emit(CartState(await _cartRepository.getCartItems()));
  }

  Future<void> clearCart() async {
    _cartRepository.clearCart();
    emit(CartState(await _cartRepository.getCartItems()));
  }

  Future<int> getCartItemCount() async {
  final cartItems = await _cartRepository.getCartItems();
  return cartItems.length;
}
}
