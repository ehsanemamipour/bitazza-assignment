
import 'dart:async';
import '../mock/mock_btc_data.dart';

class BitcoinService {
   final _priceController = StreamController<Map<String, double>>.broadcast();

   BitcoinService() {
     // initial emit
     _priceController.add(mockCurrentPrice);
     // update every minute
     Timer.periodic(const Duration(minutes: 1), (_) {
       _priceController.add(mockCurrentPrice);
     });
   }

  Map<String, double> getCurrentPrice() => mockCurrentPrice;

   Stream<Map<String, double>> get priceStream => _priceController.stream;

   List<double> getHistoricalData(String currency) {
     return mockHistoricalData[currency] ?? [];
   }

   double convertToBTC(String currency, double amount) {
     final price = mockCurrentPrice[currency];
     if (price == null || price == 0) return 0;
     return amount / price;
   }

   double convertFromBTC(String currency, double btcAmount) {
     final price = mockCurrentPrice[currency];
     if (price == null) return 0;
     return btcAmount * price;
   }

   void dispose() => _priceController.close();
 }