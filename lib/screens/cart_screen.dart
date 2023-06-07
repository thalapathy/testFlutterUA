import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cart_cubit.dart';
import '../cubits/menu_cubit.dart';
import 'package:big_burger/models/burger_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panier'),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.cartItems.isEmpty) {
            return const Center(
              child: Text('Le panier est vide'),
            );
          }
          final groupedItems = groupCartItems(state.cartItems);
          final total = calculateTotalPrice(groupedItems, context);

          return Stack(
            children: [
              ListView.builder(
                itemCount: groupedItems.length,
                itemBuilder: (context, index) {
                  final item = groupedItems[index];
                  final burger =
                      getMenuBurgerFromReference(item.ref, item.count, context);
                  return ListTile(
                    leading: burger.thumbnail != null
                        ? SizedBox(
                            width: 100.0,
                            height: 100.0,
                            child: Image.network(
                              burger.thumbnail!,
                              fit: BoxFit.contain,
                            ),
                          )
                        : const SizedBox.shrink(),
                    title: Text(burger.title),
                    subtitle: Text(
                      burger.description ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                        '${(burger.price * item.count / 100).toStringAsFixed(2)} €'),
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO payment 
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

  List<GroupedCartItem> groupCartItems(List<String> cartItems) {
    final groupedItems = <GroupedCartItem>[];
    for (final ref in cartItems) {
      final existingItem = groupedItems.firstWhere(
        (item) => item.ref == ref,
        orElse: () => GroupedCartItem(ref: ref, count: 0),
      );
      if (existingItem.count > 0) {
        existingItem.count++;
      } else {
        groupedItems.add(GroupedCartItem(ref: ref, count: 1));
      }
    }
    return groupedItems;
  }

  Burger getMenuBurgerFromReference(
      String ref, int count, BuildContext context) {
    final menuState = context.read<MenuCubit>().state;
    final burger = menuState.burgers.firstWhere((burger) => burger.ref == ref);
    return burger.copyWith(title: '${burger.title} x$count');
  }

  int calculateTotalPrice(
      List<GroupedCartItem> groupedItems, BuildContext context) {
    int total = 0;
    for (final item in groupedItems) {
      final burger = getMenuBurgerFromReference(item.ref, item.count, context);
      total += burger.price * item.count;
    }
    return total;
  }
}

class GroupedCartItem {
  final String ref;
  int count;

  GroupedCartItem({required this.ref, required this.count});
}
