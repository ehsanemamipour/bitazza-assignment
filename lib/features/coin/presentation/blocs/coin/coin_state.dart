part of 'coin_bloc.dart';

abstract class CoinState extends Equatable {
  const CoinState();
  @override
  List<Object?> get props => [];
}

class CoinInitial extends CoinState {}
class CoinLoading extends CoinState {}

class CoinLoaded extends CoinState {
  final List<Coin> coins;
  const CoinLoaded(this.coins);
  @override
  List<Object?> get props => [coins];
}

class CoinError extends CoinState {
  final String message;
  const CoinError(this.message);
  @override
  List<Object?> get props => [message];
}
