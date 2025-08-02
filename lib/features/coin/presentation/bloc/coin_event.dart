import 'package:equatable/equatable.dart';

abstract class CoinEvent extends Equatable {
  const CoinEvent();

  @override
  List<Object> get props => [];
}

class GetCoinListEvent extends CoinEvent {
  const GetCoinListEvent();
}

class DeleteFavoriteEvent extends CoinEvent {
  const DeleteFavoriteEvent({required this.coinId});
  final int coinId;
}

class AddFavoriteEvent extends CoinEvent {
  const AddFavoriteEvent({required this.coinId});
  final int coinId;
}
