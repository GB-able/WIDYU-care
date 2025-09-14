import 'package:care/models/constants/route_name.dart';
import 'package:care/providers/user_provider.dart';
import 'package:care/views/start/join_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.init();

    final profile = userProvider.profile;
    if (mounted) {
      if (profile == null) {
        context.pushReplacement(RouteName.onboarding);
      } else if (!profile.hasParents) {
        context.pushReplacement(RouteName.join,
            extra: JoinStatus.welcomeInvite);
      } else {
        context.pushReplacement(RouteName.home);
      }
    }
    await Future.delayed(const Duration(milliseconds: 1500));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
