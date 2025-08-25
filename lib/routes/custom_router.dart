import 'package:care/models/constants/route_name.dart';
import 'package:care/routes/custom_page.dart';
import 'package:care/views/start/join_view.dart';
import 'package:care/views/start/login_view.dart';
import 'package:care/views/start/onboarding_view.dart';
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
    ],
  );
}
