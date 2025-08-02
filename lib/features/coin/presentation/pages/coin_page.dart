import 'package:bitazza_assignment/core/theme/theme.dart';
import 'package:bitazza_assignment/features/coin/presentation/bloc/coin_bloc.dart';
import 'package:bitazza_assignment/features/coin/presentation/bloc/coin_event.dart';
import 'package:bitazza_assignment/features/coin/presentation/bloc/coin_state.dart';
import 'package:bitazza_assignment/features/coin/presentation/widgets/coin_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CoinPage extends StatefulWidget {
  const CoinPage({super.key});

  @override
  State<CoinPage> createState() => _CoinPageState();
}

class _CoinPageState extends State<CoinPage> {
  @override
  void initState() {
    super.initState();
    context.read<CoinBloc>().add(GetCoinListEvent());
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto Coins', style: appTheme.medium20),
        backgroundColor: appTheme.black,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: appTheme.white),
            onPressed: () => context.go('/coinPage/profilePage'),
          ),
        ],
      ),
      backgroundColor: appTheme.black,
      body: BlocConsumer<CoinBloc, CoinState>(
        listenWhen: (previous, current) {
          return current is CoinError;
        },
        listener: (context, state) {
          if (state is CoinError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        buildWhen: (previous, current) {
          return current is CoinLoading ||
              current is CoinLoaded ||
              current is CoinError ||
              current is CoinInitial;
        },
        builder: (context, state) {
          if (state is CoinLoading) {
            return Center(child: CircularProgressIndicator(color: appTheme.white));
          } else if (state is CoinLoaded) {
            return ListView.separated(
              itemCount: state.coins.length,
              separatorBuilder: (_, __) => Divider(color: appTheme.gray500),
              itemBuilder: (context, index) {
                final coin = state.coins[index];
                return CoinListItem(
                  key: ValueKey(coin.id), // Add key for better identity
                  coin: coin,
                );
              },
            );
          } else if (state is CoinError) {
            return Center(child: Text(state.message, style: appTheme.medium16.copyWith(color: Colors.red)));
          }
          return Container();
        },
      ),
    );
  }
}
