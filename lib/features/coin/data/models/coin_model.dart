import 'package:bitazza_assignment/features/coin/domain/entities/coin.dart';

class CoinModel extends Coin {
  const CoinModel({
    required super.id,
    required super.name,
    required super.price,
    required super.symbol,
    required super.iconAddress,
    required super.isFavorite,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      symbol: json['symbol'],
      iconAddress: json['icon_address'],
      isFavorite: json['is_favorite'],
    );
  }
}
