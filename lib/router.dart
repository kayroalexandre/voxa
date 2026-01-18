
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voxa/features/auth/auth_screen.dart';
import 'package:voxa/features/home/home_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const AuthScreen(),
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) {
    final user = Provider.of<User?>(context, listen: false);
    final isLoggingIn = state.matchedLocation == '/login';

    if (user == null && !isLoggingIn) {
      return '/login';
    }

    if (user != null && isLoggingIn) {
      return '/';
    }

    return null;
  },
);
