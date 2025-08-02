import 'package:bitazza_assignment/core/errors/errors.dart';
import 'package:bitazza_assignment/core/utils/usecase_utils.dart';
import 'package:bitazza_assignment/features/coin/domain/repositories/coin_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class DeleteCoinFromFavorite implements UseCase<void, DeleteCoinFromFavoriteParams> {
  DeleteCoinFromFavorite({required this.repository});
  final CoinRepository repository;

  @override
  Future<Either<Failure, void>> call(params) {
    return repository.deleteCoinFromFavorite(params.id);
  }
}

class DeleteCoinFromFavoriteParams extends Equatable {
  const DeleteCoinFromFavoriteParams({required this.id});
  final int id;

  @override
  List<Object?> get props => [id];
}
