import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:bitazza_assignment/features/coin/data/models/coin_model.dart';
import 'package:bitazza_assignment/features/coin/domain/entities/coin.dart';
import '../blocs/coin/coin_bloc.dart';

class ConvertPage extends StatefulWidget {
  const ConvertPage({super.key});

  @override
  State<ConvertPage> createState() => _ConvertPageState();
}

class _ConvertPageState extends State<ConvertPage> {
  String _selectedCurrency = 'USD';
  final TextEditingController _amountController = TextEditingController();
  double _convertedAmount = 0.0;
  List<Coin> _exchangeRates = [];
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadExchangeRates();
    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (_) => _loadExchangeRates());
  }

  void _loadExchangeRates() {
    context.read<CoinBloc>().add(LoadCoinsEvent());
  }

  double _calculateConversion() {
    final inputAmount = double.tryParse(_amountController.text) ?? 0.0;
    final rate = _exchangeRates.firstWhere(
      (coin) => coin.symbol == _selectedCurrency,
      orElse: () => CoinModel(id: 0, name: _selectedCurrency, price: 1, symbol: _selectedCurrency),
    );
    return inputAmount / rate.price.toDouble();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoinBloc, CoinState>(
      listener: (context, state) {
        if (state is CoinLoaded) {
          setState(() {
            _exchangeRates = state.coins;
            _convertedAmount = _calculateConversion();
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Convert'),
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/'),
            ),
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
                          controller: _amountController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '0',
                          ),
                          style: const TextStyle(fontSize: 18),
                          keyboardType: TextInputType.number,
                          onChanged: (_) {
                            setState(() {
                              _convertedAmount = _calculateConversion();
                            });
                          },
                        ),
                      ),
                      DropdownButton<String>(
                        value: _selectedCurrency,
                        items: _exchangeRates
                            .map((coin) => DropdownMenuItem(
                                  value: coin.symbol,
                                  child: Text(coin.symbol),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedCurrency = value;
                              _convertedAmount = _calculateConversion();
                            });
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
                    'B ${_convertedAmount.toStringAsFixed(8)} BTC',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
