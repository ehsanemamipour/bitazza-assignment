import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bitazza_assignment/features/coin/presentation/bloc/coin_bloc.dart';
import 'package:go_router/go_router.dart';

class CoinPage extends StatelessWidget {
  const CoinPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bitcoin Prices')),
      body: BlocBuilder<CoinBloc, CoinState>(
        builder: (context, state) {
          if (state is CoinLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CoinLoaded) {
            return ListView.builder(
              itemCount: state.coins.length,
              itemBuilder: (ctx, i) {
                final c = state.coins[i];
                return ListTile(
                  title: Text(c.symbol),
                  subtitle: Text(c.price.toStringAsFixed(4)),
                  onTap: () => context.go('/graph/${c.symbol}'),
                );
              },
            );
          }
          if (state is CoinError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(child: TextButton(onPressed: ()=>{}, child: const Text('Bitcoin'))),
            Expanded(child: TextButton(onPressed: ()=>context.go('/convert'), child: const Text('Convert'))),
          ],
        ),
      ),
    );
  }
}
