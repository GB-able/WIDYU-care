import 'package:care/models/constants/route_name.dart';
import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:care/views/start/login_view_model.dart';
import 'package:care/widgets/custom_app_bar.dart';
import 'package:care/widgets/custom_text_field.dart';
import 'package:care/widgets/text_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, _) => Scaffold(
          appBar: const CustomAppBar(),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Form(
              key: viewModel.formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 9, 16, 0),
                  child: Column(
                    children: [
                      Text(
                        "이메일로 로그인해요",
                        style: MyTypo.title2.copyWith(color: MyColor.grey800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "가입 시 등록한 이메일과 비밀번호를 입력해 주세요.",
                        style: MyTypo.body2.copyWith(color: MyColor.grey600),
                      ),
                      const SizedBox(height: 52),
                      CustomTextField(
                        controller: viewModel.emailCtrl,
                        hintText: "이메일을 입력해주세요.",
                        validator: viewModel.emailValidator,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: viewModel.pwCtrl,
                        hintText: "비밀번호를 입력해주세요.",
                        validator: viewModel.pwValidator,
                        obscureText: viewModel.isPwObscure,
                        suffix: GestureDetector(
                          onTap: viewModel.togglePwObscure,
                          child: SvgPicture.asset(
                            "assets/icons/ic_20_eye_${viewModel.isPwObscure ? "off" : "on"}.svg",
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40, bottom: 12),
                        child: TextBtn(
                          text: "로그인",
                          enable: true,
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            if (await viewModel.login()) {
                              print("로그인 성공"); // [TODO] 로그인 성공 후 처리
                            }
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.push(RouteName.join);
                            },
                            child: Text(
                              "회원가입",
                              style: MyTypo.button
                                  .copyWith(color: MyColor.grey600),
                            ),
                          ),
                          Row(
                            spacing: 16,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  "이메일 찾기",
                                  style: MyTypo.button
                                      .copyWith(color: MyColor.grey600),
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 16,
                                color: MyColor.grey700,
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  "비밀번호 찾기",
                                  style: MyTypo.button
                                      .copyWith(color: MyColor.grey600),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
