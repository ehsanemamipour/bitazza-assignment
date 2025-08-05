
import 'package:bitazza_assignment/data/services/bitcoin_service.dart';
import '../models/coin_model.dart';

abstract class CoinRemoteDataSource {
  Future<List<CoinModel>> getCoinList();
}

class CoinRemoteDataSourceImpl implements CoinRemoteDataSource {
  final BitcoinService bitcoinService;
  CoinRemoteDataSourceImpl({required this.bitcoinService});

  @override
  Future<List<CoinModel>> getCoinList() async {
    final prices = await bitcoinService.getCurrentPrice();
    var idx = 0;
    return prices.entries
        .map((e) => CoinModel.fromPrice(e.key, e.value, idx++))
        .toList();
  }
}
