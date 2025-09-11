import 'package:care/services/auth_service.dart';
import 'package:care/styles/typos.dart';
import 'package:care/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(canBack: false, title: "홈화면"),
      body: Center(
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            Text("테스트 버튼", style: MyTypo.title1),
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    AuthService().logout();
                  },
                  child: const Text("로그아웃"),
                ),
                ElevatedButton(
                  onPressed: () {
                    AuthService().withdraw();
                  },
                  child: const Text("회원탈퇴"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
