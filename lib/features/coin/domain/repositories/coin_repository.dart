import 'package:bitazza_assignment/core/errors/errors.dart';
import 'package:bitazza_assignment/features/coin/domain/entities/coin.dart';
import 'package:dartz/dartz.dart';

abstract class CoinRepository {
  Future<Either<Failure, List<Coin>>> getCoinList();
}
