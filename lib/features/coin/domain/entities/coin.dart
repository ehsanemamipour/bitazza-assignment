import 'package:equatable/equatable.dart';

class Coin extends Equatable {
  final int    id;
  final String name;    
  final num    price;   
  final String symbol;  

  const Coin({
    required this.id,
    required this.name,
    required this.price,
    required this.symbol,
  });

  @override
  List<Object?> get props => [id, name, price, symbol];
}
