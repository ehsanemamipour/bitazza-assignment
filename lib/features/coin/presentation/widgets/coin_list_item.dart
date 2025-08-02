import 'package:bitazza_assignment/core/theme/theme.dart';
import 'package:bitazza_assignment/features/coin/domain/entities/coin.dart';
import 'package:bitazza_assignment/features/coin/presentation/bloc/coin_bloc.dart';
import 'package:bitazza_assignment/features/coin/presentation/bloc/coin_event.dart';
import 'package:bitazza_assignment/features/coin/presentation/bloc/coin_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoinListItem extends StatefulWidget {
  final Coin coin;

  const CoinListItem({super.key, required this.coin});

  @override
  State<CoinListItem> createState() => _CoinListItemState();
}

class _CoinListItemState extends State<CoinListItem> {
  late bool _isFavorite;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.coin.isFavorite;
  }

  @override
  void didUpdateWidget(CoinListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.coin.isFavorite != widget.coin.isFavorite) {
      _isFavorite = widget.coin.isFavorite;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    return BlocListener<CoinBloc, CoinState>(
      listenWhen: (previous, current) {
        return current is CoinFavoriteSuccess && current.id == widget.coin.id;
      },
      listener: (context, state) {
        if (state is CoinFavoriteSuccess && state.id == widget.coin.id) {
          setState(() {
            _isFavorite = !_isFavorite;
            _isProcessing = false;
          });
        }
      },
      child: ListTile(
        key: ValueKey(widget.coin.id),
        leading: const Icon(Icons.monetization_on),
        title: Text(widget.coin.name, style: appTheme.medium16.copyWith(color: appTheme.white)),
        subtitle: Text(
          '${widget.coin.symbol} • \$${widget.coin.price.toStringAsFixed(2)}',
          style: appTheme.medium16.copyWith(color: appTheme.white70),
        ),
        trailing: IconButton(
          icon:
              _isProcessing
                  ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: appTheme.white),
                  )
                  : Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : appTheme.white,
                  ),
          onPressed:
              _isProcessing
                  ? null
                  : () {
                    setState(() {
                      _isProcessing = true;
                    });
                    if (_isFavorite) {
                      context.read<CoinBloc>().add(DeleteFavoriteEvent(coinId: widget.coin.id));
                    } else {
                      context.read<CoinBloc>().add(AddFavoriteEvent(coinId: widget.coin.id));
                    }
                  },
        ),
      ),
    );
  }
}
