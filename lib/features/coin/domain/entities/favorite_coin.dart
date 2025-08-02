import 'package:equatable/equatable.dart';

class FavoriteCoin extends Equatable {
  const FavoriteCoin({
    required this.id,
    required this.cryptocurrencyId,
  });

  final int id;
  final int cryptocurrencyId;



  @override
  List<Object?> get props => [id];
}