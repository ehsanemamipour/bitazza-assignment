// lib/features/coin/presentation/pages/graph_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../data/services/bitcoin_service.dart';

class GraphPage extends StatefulWidget {
  final String currency;
  const GraphPage({required this.currency, super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  final _btcService = BitcoinService();
  final List<FlSpot> _spots = [];
  late DateTime _startTimeUtc;
  late StreamSubscription<Map<String, double>> _sub;
  double _latestPrice = 0;
  double _t = 0;

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  void initState() {
    super.initState();
    // seed with mock history
    final hist = _btcService.getHistoricalData(widget.currency);
    final nowUtc = DateTime.now().toUtc();
    _startTimeUtc = nowUtc.subtract(Duration(minutes: hist.length - 1)); // backfill
    for (var i = 0; i < hist.length; i++) {
      _spots.add(FlSpot(i.toDouble(), hist[i]));
      _latestPrice = hist[i];
      _t = i + 1;
    }
    // subscribe to “live” mock updates
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
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // live price & “~” subtext
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
            // chart
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _spots,
                      isCurved: true,
                      dotData: FlDotData(show: false),
                      barWidth: 2,
                    ),
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
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (i) {
          if (i == 0)
            context.go('/');
          else
            context.go('/convert');
        },
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.currency_bitcoin), label: 'Bitcoin'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Convert'),
        ],
      ),
    );
  }
}
