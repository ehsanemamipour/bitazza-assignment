// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;
import 'core/utils/app_router.dart';
import 'features/coin/presentation/bloc/coin_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(BlocProvider<CoinBloc>(create: (_) => di.serviceLocator<CoinBloc>(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bitcoin',
      theme: ThemeData(primarySwatch: Colors.purple, scaffoldBackgroundColor: Colors.white),
      routerConfig: router,
    );
  }
}
