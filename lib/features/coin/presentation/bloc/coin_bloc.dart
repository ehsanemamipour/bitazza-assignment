import 'package:bitazza_assignment/core/utils/usecase_utils.dart';
import 'package:bitazza_assignment/features/coin/domain/usecases/add_coin_to_favorite.dart';
import 'package:bitazza_assignment/features/coin/domain/usecases/delete_coin_from_favorite.dart';
import 'package:bitazza_assignment/features/coin/domain/usecases/fetch_coin_list.dart';
import 'package:bitazza_assignment/features/coin/presentation/bloc/coin_event.dart';
import 'package:bitazza_assignment/features/coin/presentation/bloc/coin_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoinBloc extends Bloc<CoinEvent, CoinState> {
  CoinBloc({
    required this.fetchCoinList,
    required this.addCoinToFavorite,
    required this.deleteCoinFromFavorite,
  }) : super(CoinInitial()) {
    on<CoinEvent>((event, emit) async {
      if (event is GetCoinListEvent) {
        await _onGetCoinListEvent(event, emit);
      } else if (event is AddFavoriteEvent) {
        await _onAddFavoriteEvent(event, emit);
      } else if (event is DeleteFavoriteEvent) {
        await _onDeleteFavoriteEvent(event, emit);
      }
    });
  }
  final AddCoinToFavorite addCoinToFavorite;
  final DeleteCoinFromFavorite deleteCoinFromFavorite;
  final FetchCoinList fetchCoinList;

  Future<void> _onAddFavoriteEvent(AddFavoriteEvent event, Emitter<CoinState> emit) async {
    final result = await addCoinToFavorite(AddCoinToFavoriteParams(id: event.coinId));

    result.fold((error) => emit(CoinError(message: error.message)), (success) {
      if (state is CoinLoaded) {
        final currentState = state as CoinLoaded;
        final updatedCoins =
            currentState.coins.map((coin) {
              if (coin.id == event.coinId) {
                return coin.copyWith(isFavorite: true);
              }
              return coin;
            }).toList();

        emit(CoinLoaded(coins: updatedCoins));
      }

      emit(CoinFavoriteSuccess(id: event.coinId));
    });
  }

  Future<void> _onDeleteFavoriteEvent(DeleteFavoriteEvent event, Emitter<CoinState> emit) async {
    final result = await deleteCoinFromFavorite(DeleteCoinFromFavoriteParams(id: event.coinId));

    result.fold((error) => emit(CoinError(message: error.message)), (success) {
      if (state is CoinLoaded) {
        final currentState = state as CoinLoaded;
        final updatedCoins =
            currentState.coins.map((coin) {
              if (coin.id == event.coinId) {
                return coin.copyWith(isFavorite: false);
              }
              return coin;
            }).toList();

        emit(CoinLoaded(coins: updatedCoins));
      }

      emit(CoinFavoriteSuccess(id: event.coinId));
    });
  }

  Future<void> _onGetCoinListEvent(GetCoinListEvent event, Emitter<CoinState> emit) async {
    emit(CoinLoading());
    final result = await fetchCoinList(NoParams());

    emit(result.fold((error) => CoinError(message: error.message), (coins) => CoinLoaded(coins: coins)));
  }
}
