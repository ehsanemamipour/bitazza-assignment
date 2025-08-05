import 'package:bitazza_assignment/features/coin/presentation/pages/coin_page.dart';
import 'package:bitazza_assignment/features/coin/presentation/pages/convert_page.dart';
import 'package:bitazza_assignment/features/coin/presentation/pages/graph_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/coins',

  routes: [
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        int currentIndex;
        if (state.matchedLocation.startsWith('/convert')) {
          currentIndex = 1;
        } else {
          currentIndex = 0;
        }

        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              switch (index) {
                case 0:
                  context.go('/coins');
                  break;
                case 1:
                  context.go('/convert');
                  break;
              }
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.currency_bitcoin), label: 'Bitcoin'),
              BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Convert'),
            ],
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/coins',
          builder: (context, state) => const CoinPage(),
          routes: [
            GoRoute(
              path: 'graph/:currency',
              builder: (context, state) {
                final currency = state.pathParameters['currency']!;
                final initialPrice = state.extra as double? ?? 0.0;
                return GraphPage(currency: currency, initialPrice: initialPrice);
              },
            ),
          ],
        ),
        GoRoute(path: '/convert', builder: (context, state) => const ConvertPage()),
      ],
    ),
  ],
);
