import 'package:go_router/go_router.dart';
import 'package:smart_traveller_app/src/ui/edit_itinernary.dart';
import 'package:smart_traveller_app/src/ui/itinernary.dart';
import 'package:smart_traveller_app/src/ui/plan_trip_screen.dart';
import 'package:smart_traveller_app/src/ui/splash_screen.dart';
import 'package:flutter/material.dart'; // Import for Scaffold

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
        builder: (context, state) {
          // Get the itinerary data from the 'extra' parameter
          final itinerary = state.extra as Map<String, dynamic>?;

          // If data is present, show the screen
          if (itinerary != null) {
            return ItinernaryScreen(itinerary: itinerary);
          }

          // If no data (e.g., navigated via URL), redirect to the plan trip screen.
          // You could also show a dedicated error page.
          // For simplicity, we'll redirect.
          return const PlanTripScreen();
        },
      ),
      GoRoute(
        path: '/edit-itinerary',
        builder: (context, state) {
          // Also pass itinerary data to the edit screen
          final itinerary = state.extra as Map<String, dynamic>?;

          if (itinerary != null) {
            return EditItinernaryScreen();
          }

          // If no data, redirect to plan trip
          return const PlanTripScreen();
        },
      ),
    ],
  );
}
