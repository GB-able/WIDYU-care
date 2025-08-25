import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension CustomGoRoute on GoRoute {
  static GoRoute slideRoute({
    required String path,
    required Widget Function(BuildContext, GoRouterState) builder,
    String? name,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return GoRoute(
      path: path,
      name: name,
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
}
