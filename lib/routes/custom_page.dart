import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension CustomGoRoute on GoRoute {
  static const duration = Duration(milliseconds: 100);

  static GoRoute slideRoute({
    required String path,
    required Widget Function(BuildContext, GoRouterState) builder,
    String? name,
    Duration duration = duration,
    List<RouteBase> routes = const [],
  }) {
    return GoRoute(
      path: path,
      name: name,
      routes: routes,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: builder(context, state),
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
    );
  }

  static GoRoute fadeRoute({
    required String path,
    required Widget Function(BuildContext, GoRouterState) builder,
    String? name,
    Duration duration = duration,
    List<RouteBase> routes = const [],
  }) {
    return GoRoute(
      path: path,
      name: name,
      routes: routes,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: builder(context, state),
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}
