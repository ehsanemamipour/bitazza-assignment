import 'package:bitazza_assignment/core/utils/app_router.dart';
import 'package:bitazza_assignment/features/coin/presentation/bloc/coin_bloc.dart';
import 'package:bitazza_assignment/injection_container.dart' as sl;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sl.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<CoinBloc>(create: (_) => sl.serviceLocator<CoinBloc>()..add(LoadCoinsEvent())),
      ],
      child: MaterialApp.router(routerConfig: AppRouter.getRouter()),
    ),
  );
}
