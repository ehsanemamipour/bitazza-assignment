// lib/features/coin/presentation/pages/convert_page.dart

import 'dart:async';
import 'package:bitazza_assignment/features/coin/data/models/coin_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/coin_bloc.dart';
import 'package:bitazza_assignment/features/coin/domain/entities/coin.dart';

class ConvertPage extends StatefulWidget {
  const ConvertPage({super.key});
  @override
  State<ConvertPage> createState() => _ConvertPageState();
}

class _ConvertPageState extends State<ConvertPage> {
  String _curr = 'USD';
  final _ctrl = TextEditingController();
  double _out = 0.0;
  List<Coin> _rates = [];
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _refresh();
    _poll = Timer.periodic(const Duration(minutes: 1), (_) => _refresh());
  }

  void _refresh() {
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
    final amt = double.tryParse(_ctrl.text) ?? 0.0;
    final c = _rates.firstWhere(
      (e) => e.symbol == _curr,
      orElse: () => CoinModel(id: 0, name: _curr, price: 1, symbol: _curr),
    );

    setState(() {
      _out = amt / c.price.toDouble();
    });
  }

  @override
  void dispose() {
    _poll?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convert'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Text('\$', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: '0'),
                      style: const TextStyle(fontSize: 18),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _recalc(),
                    ),
                  ),
                  DropdownButton<String>(
                    value: _curr,
                    items:
                        _rates.map((e) => DropdownMenuItem(value: e.symbol, child: Text(e.symbol))).toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => _curr = v);
                        _recalc();
                      }
                    },
                    underline: const SizedBox(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Icon(Icons.swap_vert, size: 32, color: Colors.grey),
            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'B ${_out.toStringAsFixed(8)} BTC',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
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
