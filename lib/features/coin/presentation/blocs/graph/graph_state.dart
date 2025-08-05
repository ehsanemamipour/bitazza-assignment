part of 'graph_cubit.dart';

class GraphState {
  final String currency;
  final double latestPrice;
  final List<FlSpot> spots;
  final double t;
  final DateTime startTimeUtc;

  GraphState({
    required this.currency,
    required this.latestPrice,
    required this.spots,
    required this.t,
    required this.startTimeUtc,
  });

  factory GraphState.initial(String currency, double initialPrice) {
    return GraphState(
      currency: currency,
      latestPrice: initialPrice,
      spots: const [],
      t: 0.0,
      startTimeUtc: DateTime.now().toUtc(),
    );
  }

  GraphState copyWith({
    String? currency,
    double? latestPrice,
    List<FlSpot>? spots,
    double? t,
    DateTime? startTimeUtc,
  }) {
    return GraphState(
      currency: currency ?? this.currency,
      latestPrice: latestPrice ?? this.latestPrice,
      spots: spots ?? this.spots,
      t: t ?? this.t,
      startTimeUtc: startTimeUtc ?? this.startTimeUtc,
    );
  }
}