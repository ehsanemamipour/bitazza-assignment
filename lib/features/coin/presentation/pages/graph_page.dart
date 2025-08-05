// lib/features/coin/presentation/pages/graph_page.dart

import 'dart:async';
import 'package:bitazza_assignment/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../data/services/bitcoin_service.dart';

class GraphPage extends StatefulWidget {
  final String currency;
  final double initialPrice;
  const GraphPage({required this.currency, required this.initialPrice, super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  final _btcService = serviceLocator<BitcoinService>();
  final List<FlSpot> _spots = [];
  late DateTime _startTimeUtc;
  late StreamSubscription<Map<String, double>> _sub;
  double _latestPrice = 0;
  double _t = 0;

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  void initState() {
    super.initState();

    final hist = _btcService.getHistoricalData(widget.currency);
    _latestPrice = widget.initialPrice;

    final nowUtc = DateTime.now().toUtc();
    _startTimeUtc = nowUtc.subtract(Duration(minutes: hist.length - 1)); // backfill
    for (var i = 0; i < hist.length; i++) {
      _spots.add(FlSpot(i.toDouble(), hist[i]));

      _t = i + 1;
    }

    setState(() {
      _spots.add(FlSpot(_t, _latestPrice));

      _t += 1;
    });
    _sub = _btcService.priceStream.listen((prices) {
      final p = prices[widget.currency]!;
      setState(() {
        _spots.add(FlSpot(_t, p));
        _latestPrice = p;
        _t += 1;
      });
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BTC / ${widget.currency}'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/coins')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _latestPrice.toStringAsFixed(4),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '~ ${_latestPrice.toStringAsFixed(4)}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  lineBarsData: [
                    LineChartBarData(spots: _spots, dotData: FlDotData(show: false), barWidth: 2),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      axisNameSize: 24,
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) {
                          // only every 5 minutes
                          if (value % 5 != 0) return const SizedBox.shrink();
                          final dt = _startTimeUtc.add(Duration(minutes: value.toInt()));
                          final txt = '${_twoDigits(dt.hour)}:${_twoDigits(dt.minute)}';
                          return SideTitleWidget(
                            meta: meta, // ✅ new
                            child: Text(txt, style: const TextStyle(fontSize: 10)),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50, // give yourself enough room
                        interval:
                            (_spots.map((e) => e.y).reduce((a, b) => b > a ? b : a) -
                                _spots.map((e) => e.y).reduce((a, b) => b < a ? b : a)) /
                            4, // about 4 ticks
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
        ),
      ),
    );
  }
}
