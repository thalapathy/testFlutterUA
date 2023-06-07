import 'package:big_burger/screens/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/cart_cubit.dart';
import 'cubits/menu_cubit.dart';
import 'screens/cart_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MenuCubit>(
          create: (context) => MenuCubit()..fetchMenu(),
        ),
        BlocProvider<CartCubit>(
          create: (context) => CartCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Big Burger',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const MenuScreen(),
          '/cart': (context) => const CartScreen(),
        },
      ),
    );
  }
}