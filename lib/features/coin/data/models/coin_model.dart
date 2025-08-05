
import 'package:bitazza_assignment/features/coin/domain/entities/coin.dart';

class CoinModel extends Coin {
  const CoinModel({
    required super.id,
    required super.name,
    required super.price,
    required super.symbol,
  });

  factory CoinModel.fromMap(String key, Map<String, dynamic> data, int idx) {
    return CoinModel(
      id: idx,
      name: data['description'] as String,
      price: data['rate_float'] as num,
      symbol: key,
    );
  }

  factory CoinModel.fromPrice(String key, num price, int idx) {
    return CoinModel(
      id: idx,
      name: key,            
      price: price,
      symbol: key,
    );
  }
  
}
