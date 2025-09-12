import 'package:care/models/constants/route_name.dart';
import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:care/views/find/find_email_view_model.dart';
import 'package:care/widgets/text_btn.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EmailBtns extends StatelessWidget {
  const EmailBtns({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FindEmailViewModel>(
      builder: (context, viewModel, _) => Container(
        padding: EdgeInsets.fromLTRB(
            16, 12, 16, 16 + MediaQuery.of(context).padding.bottom),
        child: switch (viewModel.findStatus) {
          FindEmailStatus.identity => TextBtn(
              text: "이메일 찾기",
              onTap: viewModel.find,
              enable: viewModel.isCodeVerified &&
                  viewModel.nameCtrl.text.isNotEmpty &&
                  viewModel.phoneCtrl.text.isNotEmpty,
            ),
          FindEmailStatus.success => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    context.pushReplacement(RouteName.findPassword);
                  },
                  child: Text("비밀번호 찾기",
                      style: MyTypo.button.copyWith(color: MyColor.grey800)),
                ),
                const SizedBox(height: 12),
                TextBtn(
                  onTap: () {
                    context.pop();
                  },
                  text: "로그인하기",
                  enable: true,
                ),
              ],
            ),
          FindEmailStatus.fail => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    context.go(RouteName.join);
                  },
                  child: Text("회원가입 하러 가기",
                      style: MyTypo.button.copyWith(color: MyColor.grey800)),
                ),
                const SizedBox(height: 12),
                TextBtn(
                  onTap: viewModel.find,
                  text: "이메일 다시 찾기",
                  enable: viewModel.nameCtrl.text.isNotEmpty &&
                      viewModel.phoneCtrl.text.isNotEmpty &&
                      viewModel.isCodeVerified,
                ),
              ],
            ),
        },
      ),
    );
  }
}
