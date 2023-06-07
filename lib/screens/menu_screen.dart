import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cart_cubit.dart';
import '../cubits/menu_cubit.dart';
import 'cart_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Big Burger Menu'),
      ),
      body: BlocBuilder<MenuCubit, MenuState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Une erreur est survenue, veuillez réessayer svp'),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<MenuCubit>(context).fetchMenu();
                    },
                    child: const Text('réessayer'),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: state.burgers.length,
              itemBuilder: (context, index) {
                final burger = state.burgers[index];

                return ListTile(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.5,
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (burger.thumbnail != null)
                                SizedBox(
                                  width: 100.0,
                                  height: 100.0,
                                  child: Image.network(
                                    burger.thumbnail!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              const SizedBox(height: 16.0),
                              Text(
                                burger.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                burger.description ?? '',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${(burger.price / 100).toStringAsFixed(2)} €',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Builder(
                                    builder: (BuildContext context) {
                                      return ElevatedButton(
                                        onPressed: () {
                                          BlocProvider.of<CartCubit>(context)
                                              .addToCart(burger.ref);
                                              Navigator.pop(context);
                                        },
                                        child: const Text('Ajouter au panier'),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
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
                  trailing:
                      Text('${(burger.price / 100).toStringAsFixed(2)} €'),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
        },
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
            child: Text(
              state.cartItems.length.toString(),
              style: const TextStyle(fontSize: 18.0),
            ),
          );
        },
      ),
    );
  }
}
