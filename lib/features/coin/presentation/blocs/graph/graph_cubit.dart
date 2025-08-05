import 'dart:async';
import 'package:bitazza_assignment/core/data/services/bitcoin_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:bitazza_assignment/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'graph_state.dart';

class GraphCubit extends Cubit<GraphState> {
  final BitcoinService _btcService;
  StreamSubscription<Map<String, double>>? _sub;

  GraphCubit({
    required String currency,
    required double initialPrice,
  })  : _btcService = serviceLocator<BitcoinService>(),
        super(GraphState.initial(currency, initialPrice)) {
    _initialize();
  }

  void _initialize() {
    final hist = _btcService.getHistoricalData(state.currency);
    final nowUtc = DateTime.now().toUtc();
    final startUtc = nowUtc.subtract(Duration(minutes: hist.length - 1));

    var tIndex = hist.length.toDouble();
    final spots = <FlSpot>[];
    for (var i = 0; i < hist.length; i++) {
      spots.add(FlSpot(i.toDouble(), hist[i]));
    }
    spots.add(FlSpot(tIndex, state.latestPrice));
    tIndex += 1;

    emit(state.copyWith(spots: spots, startTimeUtc: startUtc, t: tIndex));

    _sub = _btcService.priceStream.listen((prices) {
      final newPrice = prices[state.currency]!;
      final newSpots = List<FlSpot>.from(state.spots)
        ..add(FlSpot(state.t, newPrice));
      emit(state.copyWith(
        latestPrice: newPrice,
        spots: newSpots,
        t: state.t + 1,
      ));
    });
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}