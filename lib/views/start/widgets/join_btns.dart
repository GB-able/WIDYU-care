import 'package:care/models/constants/route_name.dart';
import 'package:care/models/profile.dart';
import 'package:care/providers/user_provider.dart';
import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
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
      builder: (context, userProvider, viewModel, child) => Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 60),
        child: switch (viewModel.joinStatus) {
          JoinStatus.identityVerification => viewModel.isCodeSent
              ? Column(
                  spacing: 14,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
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
                                style: MyTypo.subTitle2
                                    .copyWith(color: MyColor.grey800),
                              )
                            ],
                          ),
                        ),
                        SvgPicture.asset(
                            "assets/icons/ic_16_chevron_right.svg"),
                      ],
                    ),
                    TextBtn(
                      onTap: () {
                        viewModel.setJoinStatus(JoinStatus.emailPassword);
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
                final profile = Profile(
                  name: viewModel.nameCtrl.text,
                  email: viewModel.emailCtrl.text,
                  phoneNumber: viewModel.phoneCtrl.text,
                );
                viewModel.join(() => userProvider.setProfile(profile));
              },
              text: "회원가입하기",
              enable: viewModel.emailCtrl.text.isNotEmpty &&
                  viewModel.pwCtrl.text.isNotEmpty &&
                  !viewModel.isDuplicated,
            ),
          JoinStatus.welcomeInvite => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Text("다른 케어러 초대 요청하기",
                      style: MyTypo.button.copyWith(color: MyColor.grey800)),
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
        },
      ),
    );
  }
}
