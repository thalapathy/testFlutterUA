import 'package:equatable/equatable.dart';

class Burger extends Equatable {
  final String ref;
  final String title;
  final String? description;
  final String? thumbnail;
  final int price;

  const Burger({
    required this.ref,
    required this.title,
    this.description,
    this.thumbnail,
    required this.price,
  });

  @override
  List<Object?> get props => [ref, title, description, thumbnail, price];
}
