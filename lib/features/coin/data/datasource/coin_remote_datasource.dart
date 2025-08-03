import 'dart:convert';
import 'package:bitazza_assignment/core/consts/consts.dart';
import 'package:bitazza_assignment/core/errors/exceptions.dart';
import 'package:bitazza_assignment/core/services/http_service.dart';
import 'package:bitazza_assignment/features/coin/data/models/coin_model.dart';

abstract class CoinRemoteDataSource {
  Future<List<CoinModel>> getCoinList();
}

class CoinRemoteDataSourceImpl implements CoinRemoteDataSource {
  final HTTPService httpService;
  CoinRemoteDataSourceImpl({required this.httpService});

  @override
  Future<List<CoinModel>> getCoinList() async {
    try {
      final response = await httpService.getData(BASE_URL + CURRENT_PRICE);
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.data);
        final bpi = json['bpi'] as Map<String, dynamic>;
        print('bpi: $bpi');
        var idx = 0;
        return bpi.entries.map((e) => CoinModel.fromMap(e.key, e.value, idx++)).toList();
      } else {
        throw ServerException(message: 'Failed to fetch BTC prices');
      }
    } catch (e) {
      print('asdasdasdasdasd');
      throw ServerException(message: 'Failed to fetch BTC prices');
    }
  }
}
