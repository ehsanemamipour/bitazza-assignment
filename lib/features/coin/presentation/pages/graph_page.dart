import 'package:bitazza_assignment/features/coin/presentation/blocs/graph/graph_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphPage extends StatelessWidget {
  final String currency;
  final double initialPrice;

  const GraphPage({required this.currency, required this.initialPrice, super.key});

  String _formatTwoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GraphCubit(currency: currency, initialPrice: initialPrice),
      child: Scaffold(
        appBar: AppBar(
          title: Text('BTC / \$currency'),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/coins')),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<GraphCubit, GraphState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.latestPrice.toStringAsFixed(4),
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '~ \${state.latestPrice.toStringAsFixed(4)}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true),
                        lineBarsData: [
                          LineChartBarData(spots: state.spots, dotData: FlDotData(show: false), barWidth: 2),
                        ],
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            axisNameSize: 24,
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              reservedSize: 32,
                              getTitlesWidget: (value, meta) {
                                if (value % 5 != 0) return const SizedBox.shrink();
                                final dt = state.startTimeUtc.add(Duration(minutes: value.toInt()));
                                final txt = '${_formatTwoDigits(dt.hour)}:${_formatTwoDigits(dt.minute)}';
                                return SideTitleWidget(
                                  meta: meta,
                                  child: Text(txt, style: const TextStyle(fontSize: 10)),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 50,
                              interval:
                                  (state.spots.map((e) => e.y).reduce((a, b) => b > a ? b : a) -
                                      state.spots.map((e) => e.y).reduce((a, b) => b < a ? b : a)) /
                                  4,
                              getTitlesWidget: (value, meta) {
                                final v = value.toStringAsFixed(0);
                                return SideTitleWidget(
                                  meta: meta,
                                  child: Text('\$$v', style: const TextStyle(fontSize: 8)),
                                );
                              },
                            ),
                          ),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
