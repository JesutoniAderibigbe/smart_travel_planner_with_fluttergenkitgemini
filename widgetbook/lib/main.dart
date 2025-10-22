import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import "main.directories.g.dart";

void main() {
  runApp(WidgetBookApp());
}

@widgetbook.App()
class WidgetBookApp extends StatelessWidget {
  const WidgetBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: directories,

      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(name: 'Light', data: ThemeData.light()),
            WidgetbookTheme(name: 'Dark', data: ThemeData.dark()),
          ],
        ),
        ViewportAddon([
          Viewports.none,
          IosViewports.iPhone12,
          IosViewports.iPhone13ProMax,
          IosViewports.iPhone13ProMax,
          //   Devices.android.samsungGalaxyS20,
          //  Devices.web.responsiveDesktop,
        ]),
      ],
    );
  }
}
