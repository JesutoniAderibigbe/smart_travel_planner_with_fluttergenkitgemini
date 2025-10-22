import 'package:flutter/material.dart';
import 'package:smart_traveller_app/src/components/coolbutton.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:smart_traveller_app/src/ui/splash_screen.dart';

@widgetbook.UseCase(name: 'Default', type: Coolbutton)
Widget coolButtonDefault(BuildContext context) {
  return Center(child: Coolbutton());
}

@widgetbook.UseCase(name: 'Splash Screen', type: SplashScreen)
Widget splashScreendefault(BuildContext context) {
  return SplashScreen();
}
