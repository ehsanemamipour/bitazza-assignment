import 'package:dartz/dartz.dart';
import 'package:bitazza_assignment/core/errors/errors.dart';
import 'package:bitazza_assignment/core/utils/network_utils.dart';
import 'package:bitazza_assignment/core/utils/repository_utils.dart';
import 'package:bitazza_assignment/features/coin/data/datasource/coin_remote_datasource.dart';
import 'package:bitazza_assignment/features/coin/domain/entities/coin.dart';
import 'package:bitazza_assignment/features/coin/domain/repositories/coin_repository.dart';

class CoinRepositoryImpl implements CoinRepository {
  final CoinRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CoinRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Coin>>> getCoinList() async {
    return requestToServer(
      await networkInfo.hasConnection,
      () => remoteDataSource.getCoinList(),
    );
  }
}
