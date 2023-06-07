import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cart_cubit.dart';
import '../cubits/menu_cubit.dart';
import 'package:big_burger/models/burger_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panier'),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.cartItems.isEmpty) {
            return Center(
              child: Text('Le panier est vide'),
            );
          }
          final total = calculateTotalPrice(state.cartItems, context);

          return Stack(
            children: [
              ListView.builder(
                itemCount: state.cartItems.length,
                itemBuilder: (context, index) {
                  final ref = state.cartItems[index];
                  return BlocBuilder<MenuCubit, MenuState>(
                    builder: (context, menuState) {
                      final burger =
                          getMenuBurgerFromReference(ref, menuState.burgers);
                      return ListTile(
                        leading: burger.thumbnail != null
                            ? Container(
                                width: 100.0,
                                height: 100.0,
                                child: Image.network(
                                  burger.thumbnail!,
                                  fit: BoxFit.contain,
                                ),
                              )
                            : SizedBox.shrink(),
                        title: Text(burger.title),
                        subtitle: Text(
                          burger.description ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                            '${(burger.price / 100).toStringAsFixed(2)} €'),
                      );
                    },
                  );
                },
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Action à effectuer lors du clic sur le bouton
                    },
                    child: Text('Payer ${(total / 100).toStringAsFixed(2)} €'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Burger getMenuBurgerFromReference(String ref, List<Burger> burgers) {
    for (final burger in burgers) {
      if (burger.ref == ref) {
        return burger;
      }
    }
    throw Exception('Burger not found');
  }

  int calculateTotalPrice(List<String> cartItems, BuildContext context) {
    final menuState = context.read<MenuCubit>().state;
    int total = 0;
    for (final ref in cartItems) {
      final burger = getMenuBurgerFromReference(ref, menuState.burgers);
      total += burger.price;
    }
    return total;
  }
}
