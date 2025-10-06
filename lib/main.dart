import 'package:flutter/material.dart';
import 'package:ofair/common/dependency_injection.dart';
import 'package:ofair/common/routing/router.dart';
import 'package:ofair/common/routing/router_config.dart';
import 'package:ofair/theme/theme.dart';
import 'package:overlay_support/overlay_support.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(const OverlaySupport.global(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Ride sharing App",
      routerConfig: routerConfig,
      theme: AppTheme.lightThemeData,
      debugShowCheckedModeBanner: false,
    );
  }
}
