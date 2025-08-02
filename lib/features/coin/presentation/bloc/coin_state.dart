import 'package:bitazza_assignment/features/coin/domain/entities/coin.dart';
import 'package:equatable/equatable.dart';

abstract class CoinState extends Equatable {
  const CoinState();

  @override
  List<Object> get props => [];
}

class CoinInitial extends CoinState {}

class CoinLoaded extends CoinState {
  const CoinLoaded({required this.coins});
  final List<Coin> coins;
  @override
  List<Object> get props => [coins];
}

class CoinLoading extends CoinState {}

class CoinFavoriteSuccess extends CoinState {
  const CoinFavoriteSuccess({required this.id});
  final int id;
  @override
  List<Object> get props => [id];
}

class CoinError extends CoinState {
  const CoinError({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}
