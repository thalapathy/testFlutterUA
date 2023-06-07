import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/burger_model.dart';

class MenuState {
  final List<Burger> burgers;
  final bool isLoading;
  final bool isError;

  const MenuState({
    required this.burgers,
    required this.isLoading,
    required this.isError,
  });

  factory MenuState.initial() => const MenuState(
        burgers: [],
        isLoading: false,
        isError: false,
      );

  MenuState copyWith({
    List<Burger>? burgers,
    bool? isLoading,
    bool? isError,
  }) {
    return MenuState(
      burgers: burgers ?? this.burgers,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
    );
  }
}

abstract class MenuEvent {}

class FetchMenuEvent extends MenuEvent {}

class MenuCubit extends Cubit<MenuState> {
  final Dio _dio = Dio();

  MenuCubit() : super(MenuState.initial());

  void fetchMenu() async {
    try {
      emit(state.copyWith(isLoading: true));

      final response = await _dio.get('https://uad.io/bigburger');
      final burgers = (response.data as List)
          .map((json) => Burger(
                ref: json['ref'],
                title: json['title'],
                description: json['description'],
                thumbnail: json['thumbnail'],
                price: json['price'],
              ))
          .toList();

      emit(state.copyWith(burgers: burgers, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, isError: true));
    }
  }
}
