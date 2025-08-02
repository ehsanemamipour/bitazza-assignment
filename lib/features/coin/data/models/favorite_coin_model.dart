import 'package:bitazza_assignment/features/coin/domain/entities/favorite_coin.dart';

class FavoriteCoinModel extends FavoriteCoin {
  const FavoriteCoinModel({required super.id, required super.cryptocurrencyId});

  factory FavoriteCoinModel.fromJson(Map<String, dynamic> json) {
    return FavoriteCoinModel(id: json['id'], cryptocurrencyId: json['cryptocurrency_id']);
  }
}
