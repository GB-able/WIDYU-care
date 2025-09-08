import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:care/utils/validators.dart';
import 'package:care/views/find/find_password_view_model.dart';
import 'package:care/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class PasswordReset extends StatelessWidget {
  const PasswordReset({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FindPasswordViewModel>(
      builder: (context, viewModel, _) => Column(
        children: [
          const SizedBox(height: 9),
          Text("비밀번호 재설정",
              style: MyTypo.title2.copyWith(color: MyColor.grey800)),
          const SizedBox(height: 4),
          Text("안전한 사용을 위해 새 비밀번호를 만들어 주세요.",
              style: MyTypo.body2.copyWith(color: MyColor.grey600)),
          const SizedBox(height: 27),
          Column(
            spacing: 12,
            children: [
              ListenableBuilder(
                listenable: viewModel.pwInput,
                builder: (context, child) {
                  return CustomTextField(
                    controller: viewModel.pwInput.ctrl,
                    hintText: "영문, 숫자, 특수기호 조합 8자~12자",
                    validator: Validators.pwValidator,
                    title: "새 비밀번호",
                    inputAction: TextInputAction.next,
                    obscureText: viewModel.pwInput.isObscure,
                    suffix: GestureDetector(
                      onTap: viewModel.pwInput.toggleObscure,
                      child: SvgPicture.asset(
                        "assets/icons/ic_20_eye_${viewModel.pwInput.isObscure ? "off" : "on"}.svg",
                        width: 20,
                        height: 20,
                      ),
                    ),
                  );
                },
              ),
              ListenableBuilder(
                listenable: viewModel.pwConfirmInput,
                builder: (context, child) {
                  return CustomTextField(
                    controller: viewModel.pwConfirmInput.ctrl,
                    hintText: "비밀번호 확인",
                    validator: (value) => Validators.chainValidators(
                      value,
                      [
                        (value) {
                          if (value != viewModel.pwInput.ctrl.text) {
                            return "비밀번호가 일치하지 않아요!";
                          }
                          return null;
                        },
                      ],
                    ),
                    title: "비밀번호 확인",
                    inputAction: TextInputAction.next,
                    obscureText: viewModel.pwConfirmInput.isObscure,
                    suffix: GestureDetector(
                      onTap: viewModel.pwConfirmInput.toggleObscure,
                      child: SvgPicture.asset(
                        "assets/icons/ic_20_eye_${viewModel.pwConfirmInput.isObscure ? "off" : "on"}.svg",
                        width: 20,
                        height: 20,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
