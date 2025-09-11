import 'package:care/models/constants/route_name.dart';
import 'package:care/models/dtos/social_login_dto.dart';
import 'package:care/models/profile.dart';
import 'package:care/routes/custom_page.dart';
import 'package:care/views/find/find_email_view.dart';
import 'package:care/views/find/find_password_view.dart';
import 'package:care/views/home/home_view.dart';
import 'package:care/views/start/integrate_view.dart';
import 'package:care/views/start/join_view.dart';
import 'package:care/views/start/join_view_model.dart';
import 'package:care/views/start/login_view.dart';
import 'package:care/views/start/onboarding_view.dart';
import 'package:care/views/start/register_parent_view.dart';
import 'package:care/views/start/splash_view.dart';
import 'package:care/views/start/welcome_view.dart';
import 'package:care/widgets/search_address_view.dart';
import 'package:go_router/go_router.dart';

class CustomRouter {
  static final router = GoRouter(
    initialLocation: RouteName.splash,
    routes: [
      CustomGoRoute.slideRoute(
        path: RouteName.splash,
        builder: (context, state) => const SplashView(),
      ),
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
        builder: (context, state) => JoinView(
            initJoinStatus:
                state.extra as JoinStatus? ?? JoinStatus.identityVerification),
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
        builder: (context, state) => const HomeView(),
      ),
      CustomGoRoute.slideRoute(
        path: RouteName.findEmail,
        builder: (context, state) => const FindEmailView(),
      ),
      CustomGoRoute.slideRoute(
        path: RouteName.findPassword,
        builder: (context, state) => const FindPasswordView(),
      ),
      CustomGoRoute.slideRoute(
        path: RouteName.integrate,
        builder: (context, state) {
          final extra = state.extra! as Map<String, dynamic>;
          final profile = extra["profile"] as Profile;
          final newProfile = extra["newProfile"] as NewProfile?;
          return IntegrateView(
            profile: profile,
            newProfile: newProfile,
          );
        },
      ),
    ],
  );
}
