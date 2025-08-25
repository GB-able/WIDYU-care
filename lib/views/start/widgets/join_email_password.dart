import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:care/views/start/join_view_model.dart';
import 'package:care/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoinEmailPassword extends StatelessWidget {
  const JoinEmailPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<JoinViewModel>(
      builder: (context, viewModel, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),
          Text("사용하실 이메일과 비밀번호를\n설정해 주세요.",
              style: MyTypo.title2.copyWith(color: MyColor.grey800)),
          const SizedBox(height: 24),
          CustomTextField(
            controller: viewModel.emailCtrl,
            hintText: "영문, 숫자를 조합하여 6~12자",
            validator: viewModel.emailValidator,
            inputAction: TextInputAction.next,
            title: "이메일",
            suffix: GestureDetector(
              onTap: () {
                viewModel.checkDuplicated();
              },
              child: Text(
                "중복확인",
                style: MyTypo.button.copyWith(
                  color: !(viewModel.isChecked)
                      ? MyColor.secondary
                      : MyColor.grey300,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: viewModel.pwCtrl,
            hintText: "영문, 숫자, 특수기호 조합하여 8~12자",
            validator: (value) => null,
            inputAction: TextInputAction.done,
            title: "비밀번호",
          ),
        ],
      ),
    );
  }
}
