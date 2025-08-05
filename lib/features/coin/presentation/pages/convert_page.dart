import 'package:bitazza_assignment/features/coin/presentation/blocs/convert/convert_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:bitazza_assignment/features/coin/presentation/blocs/coin/coin_bloc.dart';

class ConvertPage extends StatelessWidget {
  const ConvertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConvertCubit(context.read<CoinBloc>()),
      child: Scaffold(
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
          child: BlocBuilder<ConvertCubit, ConvertState>(
            builder: (context, state) {
              final cubit = context.read<ConvertCubit>();
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.purple),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text('\$', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(border: InputBorder.none, hintText: '0'),
                            style: const TextStyle(fontSize: 18),
                            keyboardType: TextInputType.number,
                            onChanged: cubit.amountChanged,
                          ),
                        ),
                        DropdownButton<String>(
                          value: state.currency,
                          items:
                              state.rates
                                  .map(
                                    (coin) => DropdownMenuItem(value: coin.symbol, child: Text(coin.symbol)),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              cubit.currencyChanged(value);
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
                      'B ${state.converted.toStringAsFixed(8)} BTC',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
