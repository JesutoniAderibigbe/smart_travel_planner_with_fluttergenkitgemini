import 'package:go_router/go_router.dart';
import 'package:smart_traveller_app/src/ui/edit_itinernary.dart';
import 'package:smart_traveller_app/src/ui/itinernary.dart';
import 'package:smart_traveller_app/src/ui/plan_trip_screen.dart';
import 'package:smart_traveller_app/src/ui/splash_screen.dart';

class Routes {
  //using GoRouter package for routing

  static GoRouter routes = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/plan-trip-screen',
        builder: (context, state) => const PlanTripScreen(),
      ),
      GoRoute(
        path: '/itinerary',
        builder: (context, state) => const ItinernaryScreen(),
      ),
      GoRoute(
        path: '/edit-itinerary',
        builder: (context, state) => const EditItinernaryScreen(),
      ),

      // GoRoute(
      //   path: '/products/:id',
      //   builder:
      //       (context, state) =>
      //           ProductDetailsScreen(productId: state.pathParameters['id']!),
      // ),
    ],
  );
}
