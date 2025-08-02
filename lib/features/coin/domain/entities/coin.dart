import 'package:equatable/equatable.dart';

class Coin extends Equatable {
  const Coin({
    required this.id,
    required this.name,
    required this.price,
    required this.symbol,
    required this.iconAddress,
    required this.isFavorite,
  });

  final int id;
  final String name;
  final num price;
  final String symbol;
  final String iconAddress;
  final bool isFavorite;

  Coin copyWith({
    int? id,
    String? name,
    String? symbol,
    num? price,
    String? iconAddress,
    bool? isFavorite,
  }) {
    return Coin(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      price: price ?? this.price,
      iconAddress: iconAddress ?? this.iconAddress,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [id];
}
