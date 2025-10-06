import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ofair/common/routing/router_names.dart';
import 'package:ofair/domain/model/ride_request_models.dart';
import 'package:ofair/screens/auth/pages/login_page.dart';
import 'package:ofair/screens/auth/pages/signup_page.dart';
import 'package:ofair/screens/home/pages/home_page.dart';
import 'package:ofair/screens/requests/pages/requests_page.dart';
import 'package:ofair/screens/requests/pages/ride_details_page.dart';
import 'package:ofair/screens/users_page.dart';

final routerConfig = GoRouter(
  initialLocation: '/auth/register',
  routes: [
    GoRoute(
      path: '/auth',
      name: RouterNames.loginPage.name,

      builder: (context, state){
        final extra  = state.extra as Map<String, dynamic>?;
        final email = extra?['email'] as String?;
        print('email in routerConfig $email');
        return const LoginPage();
      },
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
    GoRoute(
      path: '/home',
      name : RouterNames.HomePage.name,
      builder :(context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/rideDetail',
      name: RouterNames.RequestDetailPage.name,
      builder: (context, state)  {
       final ride = state.extra as RideRequestModel;
        if (ride == null) {
          return const Scaffold(
            body: Center(child: Text('No ride details provided')),
          );
        }
        return RideDetailsPage(ride: ride);
        
      }
      )
  ],
);
