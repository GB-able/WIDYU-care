import 'package:care/providers/user_provider.dart';
import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:care/utils/phone_formatter.dart';
import 'package:care/utils/validators.dart';
import 'package:care/views/start/join_view_model.dart';
import 'package:care/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class JoinApplePhone extends StatefulWidget {
  const JoinApplePhone({super.key});

  @override
  State<JoinApplePhone> createState() => _JoinApplePhoneState();
}

class _JoinApplePhoneState extends State<JoinApplePhone> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();
      final viewModel = context.read<JoinViewModel>();

      if (userProvider.profile != null) {
        viewModel.nameCtrl.text = userProvider.profile!.name;
        viewModel.emailCtrl.text = userProvider.profile!.email;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JoinViewModel>(
      builder: (context, viewModel, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),
          Text("보호자님의 본인인증을 진행해주세요.",
              style: MyTypo.title2.copyWith(color: MyColor.grey800)),
          const SizedBox(height: 24),
          Column(
            spacing: 12,
            children: [
              CustomTextField(
                controller: viewModel.nameCtrl,
                hintText: "예) 홍길동",
                validator: (value) =>
                    Validators.emptyValidator(value, data: "이름을"),
                inputAction: TextInputAction.next,
                title: "이름",
                enabled: false,
              ),
              CustomTextField(
                controller: viewModel.emailCtrl,
                hintText: "example@widyu.com",
                validator: viewModel.emailValidator,
                inputAction: TextInputAction.next,
                title: "이메일",
                enabled: false,
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
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
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
                  viewModel.timer.isEmpty || viewModel.isCodeVerified
                      ? const SizedBox.shrink()
                      : Text(
                          viewModel.timer,
                          style:
                              MyTypo.helper.copyWith(color: MyColor.secondary),
                        ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
