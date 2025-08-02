import 'package:bitazza_assignment/features/coin/presentation/pages/coin_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter getRouter() {
    return GoRouter(
      initialLocation: '/',
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (context, state) => CoinPage(),
          routes: <RouteBase>[
            // GoRoute(
            //   path: 'mainPage',
            //   builder: (context, state) => MainPage(),
            //   routes: [

            //   ],
            // ),
            GoRoute(
              path: 'coinPage',
              builder: (context, state) => CoinPage(),
              // routes: <RouteBase>[GoRoute(path: 'profilePage', builder: (context, state) => ProfilePage())],
            ),
          ],
        ),
      ],
    );
  }
}
