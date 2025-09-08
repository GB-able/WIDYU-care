import 'package:care/models/constants/route_name.dart';
import 'package:care/routes/custom_page.dart';
import 'package:care/views/find/find_email_view.dart';
import 'package:care/views/start/join_view.dart';
import 'package:care/views/start/login_view.dart';
import 'package:care/views/start/onboarding_view.dart';
import 'package:care/views/start/register_parent_view.dart';
import 'package:care/views/start/welcome_view.dart';
import 'package:care/widgets/search_address_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomRouter {
  static final router = GoRouter(
    initialLocation: RouteName.onboarding,
    routes: [
      CustomGoRoute.slideRoute(
        path: RouteName.onboarding,
        builder: (context, state) => const OnboardingView(),
      ),
      CustomGoRoute.slideRoute(
        path: RouteName.login,
        builder: (context, state) => const LoginView(),
      ),
      CustomGoRoute.slideRoute(
        path: RouteName.join,
        builder: (context, state) => const JoinView(),
      ),
      CustomGoRoute.slideRoute(
        path: RouteName.registerParent,
        builder: (context, state) => const RegisterParentView(),
      ),
      CustomGoRoute.slideRoute(
        path: RouteName.welcome,
        builder: (context, state) => const WelcomeView(),
      ),
      CustomGoRoute.slideRoute(
        path: RouteName.searchAddress,
        builder: (context, state) => const SearchAddressView(),
      ),
      CustomGoRoute.slideRoute(
        path: RouteName.home,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('홈화면'))),
      ),
      CustomGoRoute.slideRoute(
        path: RouteName.findEmail,
        builder: (context, state) => const FindEmailView(),
      ),
    ],
  );
}
