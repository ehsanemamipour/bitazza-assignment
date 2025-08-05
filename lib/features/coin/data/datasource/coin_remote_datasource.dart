import 'package:bitazza_assignment/core/data/services/bitcoin_service.dart';
import '../models/coin_model.dart';

abstract class CoinRemoteDataSource {
  Future<List<CoinModel>> getCoinList();
}

class CoinRemoteDataSourceImpl implements CoinRemoteDataSource {
  final BitcoinService bitcoinService;
  CoinRemoteDataSourceImpl({required this.bitcoinService});

  @override
  Future<List<CoinModel>> getCoinList() async {
    
    final prices = bitcoinService.getCurrentPrice();
    var idx = 0;
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));
    return prices.entries.map((e) => CoinModel.fromPrice(e.key, e.value, idx++)).toList();
  }
}
