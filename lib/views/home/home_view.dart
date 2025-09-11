import 'package:care/models/constants/route_name.dart';
import 'package:care/providers/user_provider.dart';
import 'package:care/services/auth_service.dart';
import 'package:care/styles/typos.dart';
import 'package:care/utils/show_toast.dart';
import 'package:care/widgets/account_info.dart';
import 'package:care/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    return Scaffold(
      appBar: const CustomAppBar(canBack: false, title: "홈화면"),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("테스트 및 확인용", style: MyTypo.title1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: AccountInfo(
                  type: AccountInfoType.notice,
                  name: userProvider.profile?.name ?? "",
                  phone: userProvider.profile?.phoneNumber ?? "",
                  email: userProvider.profile?.email ?? "",
                  socials: userProvider.profile?.providers ?? [],
                ),
              ),
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await AuthService().logout();
                      if (context.mounted) {
                        context.go(RouteName.onboarding);
                      }
                    },
                    child: const Text("로그아웃"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      AuthService().withdraw();
                    },
                    child: const Text("회원탈퇴"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showToast("토스트 메시지 테스트입니다.");
                    },
                    child: const Text("토스트 메시지"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text("진동 테스트", style: MyTypo.title1),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: HapticsType.values
                    .map((e) => ElevatedButton(
                          onPressed: () {
                            Haptics.vibrate(e);
                          },
                          child: Text(e.name),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
