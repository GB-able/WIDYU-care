import 'package:care/models/enums/app_route.dart';
import 'package:care/models/enums/social_type.dart';
import 'package:care/models/profile.dart';
import 'package:care/routes/custom_page.dart';
import 'package:care/views/album/album_view.dart';
import 'package:care/views/album/post_view.dart';
import 'package:care/views/find/find_email_view.dart';
import 'package:care/views/find/find_password_view.dart';
import 'package:care/views/goal/goal_view.dart';
import 'package:care/views/goal/medicine_view.dart';
import 'package:care/views/goal/walk_edit_view.dart';
import 'package:care/views/goal/walk_view.dart';
import 'package:care/views/home/home_view.dart';
import 'package:care/views/photo/photo_view.dart';
import 'package:care/views/start/integrate_view.dart';
import 'package:care/views/start/join_view.dart';
import 'package:care/views/start/join_view_model.dart';
import 'package:care/views/start/login_view.dart';
import 'package:care/views/start/onboarding_view.dart';
import 'package:care/views/start/register_parent_view.dart';
import 'package:care/views/start/splash_view.dart';
import 'package:care/views/start/welcome_view.dart';
import 'package:care/widgets/bot_nav.dart';
import 'package:care/widgets/search_address_view.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class CustomRouter {
  static final router = GoRouter(
    initialLocation: AppRoute.splash.path,
    routes: [
      StatefulShellRoute.indexedStack(
        branches: [
          StatefulShellBranch(routes: [
            CustomGoRoute.fadeRoute(
              path: AppRoute.home.path,
              name: AppRoute.home.name,
              builder: (context, state) => const HomeView(), //const NavView(),
            ),
          ]),
          StatefulShellBranch(routes: [
            CustomGoRoute.fadeRoute(
              path: AppRoute.goal.path,
              name: AppRoute.goal.name,
              builder: (context, state) => const GoalView(),
              routes: [
                CustomGoRoute.slideRoute(
                  path: AppRoute.medicine.path,
                  name: AppRoute.medicine.name,
                  builder: (context, state) => const MedicineView(),
                ),
                CustomGoRoute.slideRoute(
                  path: AppRoute.walk.path,
                  name: AppRoute.walk.name,
                  builder: (context, state) => const WalkView(),
                  routes: [],
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            CustomGoRoute.fadeRoute(
              path: AppRoute.location.path,
              name: AppRoute.location.name,
              builder: (context, state) => const Placeholder(),
            ),
          ]),
          StatefulShellBranch(routes: [
            CustomGoRoute.fadeRoute(
              path: AppRoute.album.path,
              name: AppRoute.album.name,
              builder: (context, state) => const AlbumView(),
            ),
          ]),
          StatefulShellBranch(routes: [
            CustomGoRoute.fadeRoute(
              path: AppRoute.user.path,
              name: AppRoute.user.name,
              builder: (context, state) => const Placeholder(),
            ),
          ]),
        ],
        builder: (context, state, navigationShell) => Stack(
          alignment: Alignment.bottomCenter,
          children: [navigationShell, const BotNav()],
        ),
      ),
      CustomGoRoute.fadeRoute(
        path: AppRoute.splash.path,
        name: AppRoute.splash.name,
        builder: (context, state) => const SplashView(),
      ),
      CustomGoRoute.fadeRoute(
        path: AppRoute.onboarding.path,
        name: AppRoute.onboarding.name,
        builder: (context, state) => const OnboardingView(),
      ),
      CustomGoRoute.slideRoute(
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        builder: (context, state) => const LoginView(),
      ),
      CustomGoRoute.slideRoute(
        path: AppRoute.join.path,
        name: AppRoute.join.name,
        builder: (context, state) => JoinView(
            initJoinStatus:
                state.extra as JoinStatus? ?? JoinStatus.identityVerification),
      ),
      CustomGoRoute.slideRoute(
        path: AppRoute.registerParent.path,
        name: AppRoute.registerParent.name,
        builder: (context, state) => const RegisterParentView(),
      ),
      CustomGoRoute.slideRoute(
        path: AppRoute.welcome.path,
        name: AppRoute.welcome.name,
        builder: (context, state) => const WelcomeView(),
      ),
      CustomGoRoute.slideRoute(
        path: AppRoute.searchAddress.path,
        name: AppRoute.searchAddress.name,
        builder: (context, state) => const SearchAddressView(),
      ),
      CustomGoRoute.slideRoute(
        path: AppRoute.findEmail.path,
        name: AppRoute.findEmail.name,
        builder: (context, state) => const FindEmailView(),
      ),
      CustomGoRoute.slideRoute(
        path: AppRoute.findPassword.path,
        name: AppRoute.findPassword.name,
        builder: (context, state) => const FindPasswordView(),
      ),
      CustomGoRoute.slideRoute(
        path: AppRoute.integrate.path,
        name: AppRoute.integrate.name,
        builder: (context, state) {
          final extra = state.extra! as Map<String, dynamic>;
          final profile = extra["profile"] as Profile;
          final provider = extra["provider"] as SocialType?;
          return IntegrateView(profile: profile, provider: provider);
        },
      ),
      CustomGoRoute.closeRoute(
        path: AppRoute.uploadPhoto.path,
        name: AppRoute.uploadPhoto.name,
        builder: (context, state) => const PhotoView(),
      ),
      CustomGoRoute.slideRoute(
        path: AppRoute.createPost.path,
        name: AppRoute.createPost.name,
    ],
  );
}
