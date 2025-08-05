part of 'convert_cubit.dart';


class ConvertState {
  final String currency;
  final double amount;
  final double converted;
  final List<Coin> rates;

  ConvertState({
    required this.currency,
    required this.amount,
    required this.converted,
    required this.rates,
  });

  factory ConvertState.initial() => ConvertState(
        currency: 'USD',
        amount: 0.0,
        converted: 0.0,
        rates: const [],
      );

  ConvertState copyWith({
    String? currency,
    double? amount,
    double? converted,
    List<Coin>? rates,
  }) {
    return ConvertState(
      currency: currency ?? this.currency,
      amount: amount ?? this.amount,
      converted: converted ?? this.converted,
      rates: rates ?? this.rates,
    );
  }
}