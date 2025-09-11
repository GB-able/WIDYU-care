import 'package:care/models/constants/route_name.dart';
import 'package:care/models/dtos/social_login_dto.dart';
import 'package:care/models/enums/social_type.dart';
import 'package:care/models/profile.dart';
import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:care/views/start/integrate_view_model.dart';
import 'package:care/widgets/account_info.dart';
import 'package:care/widgets/custom_app_bar.dart';
import 'package:care/widgets/text_btn.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class IntegrateView extends StatelessWidget {
  const IntegrateView(
      {super.key, required this.profile, required this.newProfile});

  final Profile profile;
  final NewProfile? newProfile;

  @override
  Widget build(BuildContext context) {
    final isLocalJoin = newProfile == null;

    return ChangeNotifierProvider(
      create: (_) => IntegrateViewModel(newProfile: newProfile),
      child: Consumer<IntegrateViewModel>(
        builder: (context, viewModel, _) => Scaffold(
          appBar: const CustomAppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 9, 16, 60),
              child: Column(
                children: [
                  const SizedBox(height: 9),
                  Text("이미 계정이 존재해요.",
                      style: MyTypo.title2.copyWith(color: MyColor.grey800)),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                        newProfile == null
                            ? "회원가입을 계속 진행해서 연동할까요?"
                            : "${SocialType.values.firstWhere((e) => e.name == newProfile!.provider.toLowerCase()).label} 계정도 연동할까요?",
                        style: MyTypo.body2.copyWith(color: MyColor.grey600)),
                  ),
                  const SizedBox(height: 24),
                  AccountInfo(
                    type: AccountInfoType.find,
                    name: profile.name,
                    phone: profile.phoneNumber ?? "",
                    email: profile.providers.contains("local")
                        ? profile.email
                        : null,
                    socials: profile.providers,
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.fromLTRB(
                16, 12, 16, 16 + MediaQuery.of(context).padding.bottom),
            child: isLocalJoin && profile.providers.contains("local")
                ? TextBtn(
                    onTap: () {
                      context.go(RouteName.onboarding);
                    },
                    text: "기존 계정으로 로그인",
                    enable: true,
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.go(RouteName.onboarding);
                        },
                        child: Text("기존 계정으로 로그인",
                            style:
                                MyTypo.button.copyWith(color: MyColor.grey800)),
                      ),
                      const SizedBox(height: 12),
                      TextBtn(
                        onTap: () async {
                          if (isLocalJoin) {
                            context.pop();
                          } else {
                            await viewModel.integrate();
                            if (context.mounted) {
                              context.go(RouteName.home);
                            }
                          }
                        },
                        text: "연동하기",
                        enable: true,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
