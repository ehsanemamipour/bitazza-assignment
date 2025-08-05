import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bitazza_assignment/core/utils/usecase_utils.dart';
import 'package:bitazza_assignment/features/coin/domain/entities/coin.dart';
import 'package:bitazza_assignment/features/coin/domain/usecases/fetch_coin_list.dart';
import 'package:equatable/equatable.dart';

part 'coin_event.dart';
part 'coin_state.dart';

class CoinBloc extends Bloc<CoinEvent, CoinState> {
  final FetchCoinList fetchCoinList;
  Timer? _timer;

  CoinBloc({required this.fetchCoinList}) : super(CoinInitial()) {
    on<LoadCoinsEvent>(_onLoadCoins);
    on<StartAutoRefreshEvent>(_onStartAutoRefresh);

    add(LoadCoinsEvent());
    add(StartAutoRefreshEvent());
  }

  Future<void> _onLoadCoins(LoadCoinsEvent event, Emitter<CoinState> emit) async {
    emit(CoinLoading());
    final res = await fetchCoinList(NoParams());
    res.fold((f) => emit(CoinError(f.message)), (coins) => emit(CoinLoaded(coins)));
  }

  Future<void> _onStartAutoRefresh(StartAutoRefreshEvent event, Emitter<CoinState> emit) async {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 60), (_) {
      add(LoadCoinsEvent());
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
