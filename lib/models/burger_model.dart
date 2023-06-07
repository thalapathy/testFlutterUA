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

  Burger copyWith({
    String? ref,
    String? title,
    String? description,
    int? price,
    String? thumbnail,
  }) {
    return Burger(
      ref: ref ?? this.ref,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }

  @override
  List<Object?> get props => [ref, title, description, thumbnail, price];
}
