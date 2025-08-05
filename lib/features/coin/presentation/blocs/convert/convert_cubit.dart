import 'dart:async';
import 'package:bitazza_assignment/features/coin/data/models/coin_model.dart';
import 'package:bitazza_assignment/features/coin/domain/entities/coin.dart';
import 'package:bitazza_assignment/features/coin/presentation/blocs/coin/coin_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'convert_state.dart';


class ConvertCubit extends Cubit<ConvertState> {
  final CoinBloc _coinBloc;
  late final StreamSubscription _coinSub;
  late final Timer _refreshTimer;

  ConvertCubit(this._coinBloc)
      : super(ConvertState.initial()) {
    // Listen for coin updates
    _coinSub = _coinBloc.stream.listen((coinState) {
      if (coinState is CoinLoaded) {
        final rates = coinState.coins;
        _onRatesUpdated(rates);
      }
    });

    _load();
    // Refresh every minute
    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (_) => _load());
  }

  void _load() {
    _coinBloc.add(LoadCoinsEvent());
  }

  void _onRatesUpdated(List<Coin> rates) {
    final converted = _computeConversion(state.amount, state.currency, rates);
    emit(state.copyWith(rates: rates, converted: converted));
  }

  void amountChanged(String text) {
    final amt = double.tryParse(text) ?? 0.0;
    final converted = _computeConversion(amt, state.currency, state.rates);
    emit(state.copyWith(amount: amt, converted: converted));
  }

  void currencyChanged(String symbol) {
    final converted = _computeConversion(state.amount, symbol, state.rates);
    emit(state.copyWith(currency: symbol, converted: converted));
  }

  double _computeConversion(double amount, String currency, List<Coin> rates) {
    final rate = rates.firstWhere(
      (c) => c.symbol == currency,
      orElse: () => CoinModel(
          id: 0, name: currency, price: 1, symbol: currency),
    );
    return rate.price != 0 ? amount / rate.price.toDouble() : 0.0;
  }

  @override
  Future<void> close() {
    _coinSub.cancel();
    _refreshTimer.cancel();
    return super.close();
  }
}