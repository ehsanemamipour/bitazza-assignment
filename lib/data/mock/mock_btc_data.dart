import 'dart:math';

const Map<String, double> _basePrices = {'USD': 120000.0, 'GBP': 110000.0, 'EUR': 112000.0};

const double _defaultVolatility = 0.015;

final Random _rng = Random();

Map<String, List<double>> generateMockHistoricalData({
  int length = 30,
  double volatility = _defaultVolatility,
}) {
  final result = <String, List<double>>{};
  _basePrices.forEach((currency, start) {
    var price = start;
    var series = <double>[];
    for (var i = 0; i < length; i++) {
      final change = (_rng.nextDouble() * 2 - 1) * volatility;
      price = price * (1 + change);
      series.add(double.parse(price.toStringAsFixed(4)));
    }
    result[currency] = series;
  });
  return result;
}

Map<String, double> generateMockCurrentPrice({
  int historyLength = 30,
  double volatility = _defaultVolatility,
}) {
  final hist = generateMockHistoricalData(length: historyLength, volatility: volatility);
 

  return {for (var entry in hist.entries) entry.key: entry.value.last};
}

final mockHistoricalData = generateMockHistoricalData(length: 10);

Map<String, double> get mockCurrentPrice => generateMockCurrentPrice();
