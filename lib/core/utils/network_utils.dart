import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get hasConnection;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl({required this.dataConnectionChecker});

  final Connectivity dataConnectionChecker;
  @override
  Future<bool> get hasConnection async {
    final connection = await dataConnectionChecker.checkConnectivity();

    return connection.contains(ConnectivityResult.mobile) ||
        connection.contains(ConnectivityResult.wifi) ||
        connection.contains(ConnectivityResult.ethernet) ||
        connection.contains(ConnectivityResult.vpn) ||
        connection.contains(ConnectivityResult.other);
  }
}
