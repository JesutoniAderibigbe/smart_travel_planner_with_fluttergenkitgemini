import 'package:flutter/material.dart';
import 'package:smart_traveller_app/src/constants/themes.dart';

import 'package:smart_traveller_app/src/routes/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: appTheme,
      routerConfig: Routes.routes,
    );
  }
}
