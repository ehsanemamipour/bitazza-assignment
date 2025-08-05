// lib/features/coin/presentation/pages/coin_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../blocs/coin/coin_bloc.dart';

class CoinPage extends StatefulWidget {
  const CoinPage({super.key});
  @override
  State<CoinPage> createState() => _CoinPageState();
}

class _CoinPageState extends State<CoinPage> {
  DateTime _lastUpdate = DateTime.now().toUtc();

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('MMM d, yyyy HH:mm:ss');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitcoin'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: BlocConsumer<CoinBloc, CoinState>(
        listener: (context, state) {
          if (state is CoinLoaded) {
            _lastUpdate = DateTime.now().toUtc();
          }
        },
        builder: (context, state) {
          if (state is CoinLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CoinError) {
            return Center(child: Text(state.message));
          }
          if (state is CoinLoaded) {
            return Column(
              children: [
                // timestamp
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Last update: ${df.format(_lastUpdate)} UTC',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ),
                const Divider(height: 1),
                // list of rates
                Expanded(
                  child: ListView.separated(
                    itemCount: state.coins.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, index) {
                      final coin = state.coins[index];
                      return ListTile(
                        title: Text(
                          'BTC / ${coin.symbol}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              coin.price.toStringAsFixed(4),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '£${coin.price.toStringAsFixed(4)}',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        onTap: () => context.go('/coins/graph/${coin.symbol}', extra: coin.price),

                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        horizontalTitleGap: 0,
                        minVerticalPadding: 16,
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
