import 'package:bitazza_assignment/core/errors/errors.dart';
import 'package:bitazza_assignment/core/utils/usecase_utils.dart';
import 'package:bitazza_assignment/features/coin/domain/entities/coin.dart';
import 'package:bitazza_assignment/features/coin/domain/repositories/coin_repository.dart';
import 'package:dartz/dartz.dart';

class FetchCoinList implements UseCase<List<Coin>, NoParams> {
  FetchCoinList({required this.repository});
  final CoinRepository repository;

  @override
  Future<Either<Failure, List<Coin>>> call(params) {
    return repository.getCoinList();
  }
}
