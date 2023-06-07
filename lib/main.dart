import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/menu_cubit.dart';
import 'models/burger_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Big Burger',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => MenuCubit()..fetchMenu(),
        child: const MenuScreen(),
      ),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

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
            return const Center(child: Text('Failed to fetch menu'));
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
                            maxHeight: MediaQuery.of(context).size.height *
                                0.5, 
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              burger.thumbnail != null
                                  ? SizedBox(
                                      width: 100.0,
                                      height: 100.0,
                                      child: Image.network(
                                        burger.thumbnail!,
                                        fit: BoxFit.contain,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
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
                                        fontSize: 16.0),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Ajouter la logique pour ajouter le burger au panier
                                      // ...
                                    },
                                    child: const Text('Ajouter au panier'),
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
                      ? Container(
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
                  trailing: Text('${(burger.price / 100).toStringAsFixed(2)} €'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
