import 'package:care/models/constants/route_name.dart';
import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:care/views/find/find_password_view_model.dart';
import 'package:care/widgets/text_btn.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PasswordBtns extends StatelessWidget {
  const PasswordBtns({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FindPasswordViewModel>(
      builder: (context, viewModel, _) => Container(
        padding: EdgeInsets.fromLTRB(
            16, 12, 16, 16 + MediaQuery.of(context).padding.bottom),
        child: switch (viewModel.findStatus) {
          FindPasswordStatus.identity => TextBtn(
              text: "비밀번호 재설정",
              onTap: () {
                viewModel.checkCanReset();
                if (viewModel.canReset) {
                  viewModel.setFindStatus(FindPasswordStatus.success);
                } else {
                  viewModel.setFindStatus(FindPasswordStatus.fail);
                }
              },
              enable: viewModel.isCodeVerified &&
                  viewModel.emailCtrl.text.isNotEmpty &&
                  viewModel.nameCtrl.text.isNotEmpty &&
                  viewModel.phoneCtrl.text.isNotEmpty,
            ),
          FindPasswordStatus.success => TextBtn(
              onTap: () {
                viewModel.reset();
                context.go(RouteName.login);
              },
              text: "비밀번호 변경",
              enable: viewModel.pwInput.ctrl.text.isNotEmpty &&
                  viewModel.pwConfirmInput.ctrl.text.isNotEmpty,
            ),
          FindPasswordStatus.fail => Column(
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
                  onTap: () {
                    viewModel.checkCanReset();
                    if (viewModel.canReset) {
                      viewModel.setFindStatus(FindPasswordStatus.success);
                    } else {
                      viewModel.setFindStatus(FindPasswordStatus.fail);
                    }
                  },
                  text: "비밀번호 재설정",
                  enable: viewModel.nameCtrl.text.isNotEmpty &&
                      viewModel.emailCtrl.text.isNotEmpty &&
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
