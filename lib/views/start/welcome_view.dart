import 'package:care/models/constants/route_name.dart';
import 'package:care/providers/user_provider.dart';
import 'package:care/styles/colors.dart';
import 'package:care/styles/effects.dart';
import 'package:care/styles/typos.dart';
import 'package:care/views/start/widgets/start_progress_bar.dart';
import 'package:care/widgets/account_info.dart';
import 'package:care/widgets/custom_app_bar.dart';
import 'package:care/widgets/text_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Scaffold(
          appBar: const CustomAppBar(canBack: false),
          body: Column(
            children: [
              const StartProgressBar(),
              Expanded(
                child: SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 27),
                        child: Text("환영해요, 보호자님!",
                            style:
                                MyTypo.title2.copyWith(color: MyColor.grey800)),
                      ),
                      AccountInfo(
                        type: AccountInfoType.notice,
                        name: userProvider.profile!.name,
                        phone: userProvider.profile!.phoneNumber!,
                        email: userProvider.profile!.email,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 60, bottom: 24),
                        child: Text(
                          "아래 초대숫자로 부모님 계정에\n로그인해 주세요.",
                          style: MyTypo.title2.copyWith(color: MyColor.grey800),
                        ),
                      ),
                      Column(
                        spacing: 24,
                        children: userProvider.parents!
                            .map((parent) => _buildInviteCode(
                                parent.name, parent.inviteCode))
                            .toList(),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                )),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),
            child: TextBtn(
              text: "서비스 시작하기!",
              enable: true,
              onTap: () {
                context.go(RouteName.home);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildInviteCode(String name, String code) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: MyColor.white,
        boxShadow: [MyEffects.shadow],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
        child: Column(
          spacing: 12,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: name,
                    style: MyTypo.title3.copyWith(color: MyColor.primary),
                  ),
                  TextSpan(
                    text: "님 로그인용 초대숫자",
                    style: MyTypo.title3.copyWith(color: MyColor.grey800),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                Text(code, style: MyTypo.title2),
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: SvgPicture.asset("assets/icons/ic_16_share.svg"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
