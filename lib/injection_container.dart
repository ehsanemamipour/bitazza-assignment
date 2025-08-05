import 'package:bitazza_assignment/core/services/http_service.dart';
import 'package:bitazza_assignment/core/utils/network_utils.dart';
import 'package:bitazza_assignment/data/services/bitcoin_service.dart';
import 'package:bitazza_assignment/features/coin/data/datasource/coin_remote_datasource.dart';
import 'package:bitazza_assignment/features/coin/data/repositories/coin_repository_impl.dart';
import 'package:bitazza_assignment/features/coin/domain/repositories/coin_repository.dart';
import 'package:bitazza_assignment/features/coin/domain/usecases/fetch_coin_list.dart';
import 'package:bitazza_assignment/features/coin/presentation/bloc/coin_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  _injectExternalLibraries();
  _injectSystemStatus();
  _injectCoin();
}

void _injectCoin() {
  serviceLocator.registerLazySingleton<BitcoinService>(() => BitcoinService());
  //bloc
  serviceLocator.registerFactory(() => CoinBloc(fetchCoinList: serviceLocator()));
  //usecase
  serviceLocator.registerLazySingleton(() => FetchCoinList(repository: serviceLocator()));

  //repositories
  serviceLocator.registerLazySingleton<CoinRepository>(
    () => CoinRepositoryImpl(networkInfo: serviceLocator(), remoteDataSource: serviceLocator()),
  );
  //datasources
  serviceLocator.registerLazySingleton<CoinRemoteDataSource>(
    () => CoinRemoteDataSourceImpl(bitcoinService: serviceLocator()),
  );
}

void _injectExternalLibraries() {
  serviceLocator.registerLazySingleton<HTTPService>(() => DioService(dio: Dio()));
  //Data Connection Checker
  serviceLocator.registerLazySingleton(() => Connectivity());
}

void _injectSystemStatus() {
  // system Statuses
  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(dataConnectionChecker: serviceLocator()),
  );
}
