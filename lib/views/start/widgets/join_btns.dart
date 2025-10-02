import 'package:care/models/constants/route_name.dart';
import 'package:care/providers/user_provider.dart';
import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:care/utils/show_toast.dart';
import 'package:care/views/start/join_view_model.dart';
import 'package:care/widgets/text_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class JoinBtns extends StatelessWidget {
  const JoinBtns({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, JoinViewModel>(
      builder: (context, userProvider, viewModel, child) {
        final privacyRow = Row(
          children: [
            Expanded(
              child: Row(
                spacing: 12,
                children: [
                  GestureDetector(
                    onTap: viewModel.toggleAgree,
                    child: SvgPicture.asset(
                      "assets/icons/ic_24_checkbox_${viewModel.isAgreed ? "on" : "off"}.svg",
                      colorFilter: const ColorFilter.mode(
                        MyColor.grey500,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Text(
                    "(필수) 개인정보 수집 동의",
                    style: MyTypo.subTitle2.copyWith(color: MyColor.grey800),
                  )
                ],
              ),
            ),
            SvgPicture.asset("assets/icons/ic_16_chevron_right.svg"),
          ],
        );

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 60),
          child: switch (viewModel.joinStatus) {
            JoinStatus.identityVerification => viewModel.isCodeSent
                ? Column(
                    spacing: 14,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      privacyRow,
                      TextBtn(
                        onTap: () async {
                          final profile = await viewModel.getJoinedProfile();
                          if (!context.mounted) return;

                          if (profile != null) {
                            context.push(RouteName.integrate, extra: {
                              "profile": profile,
                              "newProfile": null,
                            });
                            viewModel.setJoinStatus(JoinStatus.emailPassword);
                          } else {
                            viewModel.setJoinStatus(JoinStatus.emailPassword);
                          }
                        },
                        text: "다음",
                        enable: viewModel.isCodeVerified &&
                            viewModel.nameCtrl.text.isNotEmpty &&
                            viewModel.phoneCtrl.text.isNotEmpty &&
                            viewModel.isAgreed,
                      )
                    ],
                  )
                : const SizedBox.shrink(),
            JoinStatus.emailPassword => TextBtn(
                onTap: () {
                  viewModel.join(() async {
                    await userProvider.init();
                    viewModel.setJoinStatus(JoinStatus.welcomeInvite);
                  }, (String errorMsg) {
                    showToast(errorMsg);
                  });
                },
                text: "회원가입하기",
                enable: viewModel.emailCtrl.text.isNotEmpty &&
                    viewModel.pwCtrl.text.isNotEmpty &&
                    !viewModel.isDuplicated,
              ),
            JoinStatus.welcomeInvite => userProvider.profile!.hasParents
                ? TextBtn(
                    onTap: () {
                      context.go(RouteName.home);
                    },
                    text: "서비스 시작",
                    enable: true,
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Text("다른 케어러 초대 요청하기",
                            style:
                                MyTypo.button.copyWith(color: MyColor.grey800)),
                      ),
                      const SizedBox(height: 18),
                      TextBtn(
                        onTap: () {
                          userProvider.nextStep();
                          context.push(RouteName.registerParent);
                        },
                        text: "계속해서 부모님 계정 생성",
                        enable: true,
                      ),
                    ],
                  ),
            JoinStatus.applePhone => Column(
                spacing: 14,
                mainAxisSize: MainAxisSize.min,
                children: [
                  privacyRow,
                  TextBtn(
                    onTap: () async {
                      final profile = await viewModel.getJoinedProfile();
                      if (!context.mounted) return;

                      if (profile != null) {
                        context.push(RouteName.integrate, extra: {
                          "profile": profile,
                          "newProfile": null,
                        });
                      } else {
                        await viewModel.updateApplePhone().then((_) {
                          if (!context.mounted) return;
                          userProvider.nextStep();
                          context.push(RouteName.registerParent);
                        });
                      }
                    },
                    text: "다음",
                    enable: viewModel.isCodeVerified &&
                        viewModel.nameCtrl.text.isNotEmpty &&
                        viewModel.phoneCtrl.text.isNotEmpty &&
                        viewModel.isAgreed,
                  )
                ],
              ),
          },
        );
      },
    );
  }
}
