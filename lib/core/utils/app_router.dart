import 'package:bitazza_assignment/features/coin/presentation/pages/coin_page.dart';
import 'package:bitazza_assignment/features/coin/presentation/pages/convert_page.dart';
import 'package:bitazza_assignment/features/coin/presentation/pages/graph_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter getRouter() {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/',       builder: (c, s) => CoinPage()),
        GoRoute(path: '/convert',builder: (c, s) => ConvertPage()),
        GoRoute(
          path: '/graph/:currency',
          builder: (c, s) => GraphPage(currency: s.pathParameters['currency']!),
        ),
      ],
    );
  }
}
