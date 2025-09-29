import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ofair/common/routing/router_names.dart';
import 'package:ofair/screens/auth/pages/login_page.dart';
import 'package:ofair/screens/auth/pages/signup_page.dart';
import 'package:ofair/screens/requests/pages/requests_page.dart';
import 'package:ofair/screens/users_page.dart';

final routerConfig = GoRouter(
  initialLocation: '/auth/register',
  routes: [
    GoRoute(
      path: '/auth',
      name: RouterNames.loginPage.name,

      builder: (context, state) => const LoginPage(),
      routes: [
        GoRoute(
          path: '/register',
          name: RouterNames.registerPage.name,
          builder: (context, state) => const SignupPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/users',
      name: RouterNames.usersPage.name,
      builder: (context, state) => const UsersPage(),
    ),
  ],
);
