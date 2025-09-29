import 'package:flutter/material.dart';
import 'package:ofair/common/dependency_injection.dart';
import 'package:ofair/common/routing/router.dart';
import 'package:ofair/common/routing/router_config.dart';
import 'package:ofair/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  runApp(const MainApp());
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
