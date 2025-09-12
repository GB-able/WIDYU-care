import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:care/utils/phone_formatter.dart';
import 'package:care/views/find/find_email_view_model.dart';
import 'package:care/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EmailRefind extends StatelessWidget {
  const EmailRefind({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FindEmailViewModel>(
      builder: (context, viewModel, _) => Column(
        children: [
          Image.asset("assets/images/img_94_warning.png",
              width: 94, height: 94),
          const SizedBox(height: 10),
          Text("등록된 정보와 일치하는 이메일이 없어요",
              style: MyTypo.title2.copyWith(color: MyColor.grey800)),
          const SizedBox(height: 4),
          Text("혹시 정보를 잘못 입력하지는 않았나요?",
              style: MyTypo.body2.copyWith(color: MyColor.grey600)),
          const SizedBox(height: 50),
          Column(
            spacing: 12,
            children: [
              CustomTextField(
                controller: viewModel.nameCtrl,
                hintText: "예) 홍길동",
                validator: (value) => null,
                title: "이름",
                inputAction: TextInputAction.next,
              ),
              CustomTextField(
                controller: viewModel.phoneCtrl,
                hintText: "숫자만 입력",
                validator: (value) => null,
                keyboardType: TextInputType.number,
                title: "연락처",
                enabled: !viewModel.isCodeSent,
                suffix: GestureDetector(
                  onTap: viewModel.sendVerificationCode,
                  child: Text(
                    viewModel.isCodeSent ? "재전송" : "인증번호 전송",
                    style: MyTypo.button.copyWith(
                      color: viewModel.canSend
                          ? MyColor.secondary
                          : MyColor.grey400,
                    ),
                  ),
                ),
                maxLength: 13,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  PhoneFormatter(),
                ],
                inputAction: TextInputAction.next,
              ),
              if (viewModel.isCodeSent)
                Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: viewModel.codeCtrl,
                      hintText: "인증번호 입력",
                      validator: viewModel.codeValidator,
                      keyboardType: TextInputType.number,
                      title: "인증번호",
                      focusNode: viewModel.codeFocus,
                      suffix: GestureDetector(
                        onTap: viewModel.verifyCode,
                        child: Text(
                          "인증 완료",
                          style: !viewModel.isCodeVerified
                              ? MyTypo.button.copyWith(color: MyColor.secondary)
                              : MyTypo.button.copyWith(color: MyColor.grey400),
                        ),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      inputAction: TextInputAction.done,
                      enabled: !viewModel.isCodeVerified,
                    ),
                    viewModel.timer.isEmpty
                        ? const SizedBox.shrink()
                        : Text(viewModel.timer,
                            style: MyTypo.helper
                                .copyWith(color: MyColor.secondary)),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
