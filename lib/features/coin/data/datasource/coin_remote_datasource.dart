import 'package:bitazza_assignment/core/consts/consts.dart';
import 'package:bitazza_assignment/core/errors/exceptions.dart';
import 'package:bitazza_assignment/core/services/http_service.dart';
import 'package:bitazza_assignment/features/coin/data/models/coin_model.dart';
import 'package:bitazza_assignment/features/coin/data/models/favorite_coin_model.dart';

abstract class CoinRemoteDataSource {
  Future<List<CoinModel>> getCoinList();
  Future<List<FavoriteCoinModel>> getFavoriteCoinList();
  Future<void> addCoinToFavorite(int id);
  Future<void> deleteCoinFromFavorite(int id);
}

class CoinRemoteDataSourceImpl extends CoinRemoteDataSource {
  CoinRemoteDataSourceImpl({required this.httpService});
  final HTTPService httpService;

  @override
  Future<List<CoinModel>> getCoinList() async {
    try {
      final result = await httpService.getData(ServerPaths.coinList);
      List<dynamic> data = result.data;
      var coins =
          data.map((coin) {
            return CoinModel.fromJson(coin);
          }).toList();

      return coins;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<FavoriteCoinModel>> getFavoriteCoinList() async {
    try {
      final result = await httpService.getData(ServerPaths.favoriteCoin);
      List<dynamic> data = result.data;
      var coins =
          data.map((coin) {
            return FavoriteCoinModel.fromJson(coin);
          }).toList();
      return coins;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> addCoinToFavorite(int id) async {
    try {
      await httpService.postData(ServerPaths.favoriteCoin, data: {'cryptocurrency_id': id});
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteCoinFromFavorite(int id) async {
    try {
      await httpService.deleteData('${ServerPaths.favoriteCoin}/$id');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
