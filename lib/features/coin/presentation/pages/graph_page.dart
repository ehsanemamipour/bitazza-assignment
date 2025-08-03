import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bitazza_assignment/features/coin/domain/entities/coin.dart';
import 'package:bitazza_assignment/features/coin/presentation/bloc/coin_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphPage extends StatefulWidget {
  final String currency;
  const GraphPage({required this.currency, super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  final List<FlSpot> spots = [];
  double _t = 0;
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _addPoint();
    _poll = Timer.periodic(const Duration(minutes: 1), (_) => _addPoint());
  }

  void _addPoint() {
    final st = context.read<CoinBloc>().state;
    if (st is CoinLoaded) {
      final c = st.coins.firstWhere((e) => e.symbol == widget.currency);
      setState(() {
        spots.add(FlSpot(_t, c.price.toDouble()));
        _t += 1;
      });
    }
    context.read<CoinBloc>().add(LoadCoinsEvent());
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.currency} Graph')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                dotData: FlDotData(show: false),
              ),
            ],
            titlesData: FlTitlesData(show: false),
          ),
        ),
      ),
    );
  }
}
