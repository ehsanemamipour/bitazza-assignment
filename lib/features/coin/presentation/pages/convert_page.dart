import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bitazza_assignment/features/coin/presentation/bloc/coin_bloc.dart';
import 'package:bitazza_assignment/features/coin/domain/entities/coin.dart';

class ConvertPage extends StatefulWidget {
  const ConvertPage({super.key});
  @override
  State<ConvertPage> createState() => _ConvertPageState();
}

class _ConvertPageState extends State<ConvertPage> {
  String _curr = 'USD';
  final _ctrl = TextEditingController();
  double _out = 0;
  Timer? _poller;
  List<Coin> _rates = [];

  @override
  void initState() {
    super.initState();
    _refreshRates();
    _poller = Timer.periodic(const Duration(minutes: 1), (_) => _refreshRates());
  }

  void _refreshRates() {
    context.read<CoinBloc>().add(LoadCoinsEvent());
    final st = context.read<CoinBloc>().state;
    if (st is CoinLoaded) {
      setState(() {
        _rates = st.coins;
        _recalc();
      });
    }
  }

  void _recalc() {
    final amt = double.tryParse(_ctrl.text) ?? 0;
    final c = _rates.firstWhere((e) => e.symbol == _curr, orElse: ()=>Coin(id:0,name:'',price:1,symbol:'USD'));
    setState(() {
      _out = amt / c.price.toDouble();
    });
  }

  @override
  void dispose() {
    _poller?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('Convert')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _ctrl,
              decoration: InputDecoration(labelText: 'Amount ($_curr)'),
              keyboardType: TextInputType.number,
              onChanged: (_) => _recalc(),
            ),
            DropdownButton<String>(
              value: _curr,
              items: _rates
                  .map((e) => DropdownMenuItem(value: e.symbol, child: Text(e.symbol)))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  setState(() => _curr = v);
                  _recalc();
                }
              },
            ),
            const SizedBox(height: 20),
            Text('BTC: ${_out.toStringAsFixed(8)}'),
          ],
        ),
      ),
    );
  }
}
