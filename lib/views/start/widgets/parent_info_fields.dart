import 'package:care/styles/colors.dart';
import 'package:care/styles/effects.dart';
import 'package:care/styles/typos.dart';
import 'package:care/utils/birth_formatter.dart';
import 'package:care/utils/phone_formatter.dart';
import 'package:care/utils/validators.dart';
import 'package:care/views/start/register_parent_view_model.dart';
import 'package:care/widgets/address_field.dart';
import 'package:care/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class ParentInfoFields extends StatelessWidget {
  const ParentInfoFields(
      {super.key,
      required this.mode,
      required this.account,
      required this.removeAccount,
      required this.setMode});

  final InputMode mode;
  final ParentInput account;
  final VoidCallback removeAccount;
  final Function(InputMode) setMode;

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case InputMode.edit:
        return Column(
          spacing: 24,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "부모님의 계정을 생성해주세요",
              style: MyTypo.title2.copyWith(color: MyColor.grey800),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 20),
              decoration: BoxDecoration(
                color: MyColor.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [MyEffects.shadow],
              ),
              child: Form(
                key: account.formKey,
                child: Column(
                  spacing: 40,
                  children: [
                    Column(
                      spacing: 12,
                      children: [
                        CustomTextField(
                          controller: account.nameCtrl,
                          hintText: "예) 홍길동",
                          validator: (value) =>
                              Validators.emptyValidator(value, data: "이름을"),
                          title: "이름",
                          inputAction: TextInputAction.next,
                        ),
                        CustomTextField(
                          controller: account.birthDateCtrl,
                          hintText: "1990. 01. 01",
                          validator: (value) =>
                              Validators.birthValidator(value),
                          title: "생년월일",
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            BirthFormatter(),
                          ],
                          keyboardType: TextInputType.number,
                          inputAction: TextInputAction.next,
                          maxLength: 12,
                        ),
                        CustomTextField(
                          controller: account.phoneNumberCtrl,
                          hintText: "010 0000 0000",
                          validator: (value) =>
                              Validators.phoneValidator(value),
                          title: "연락처",
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            PhoneFormatter(),
                          ],
                          keyboardType: TextInputType.number,
                          inputAction: TextInputAction.done,
                          maxLength: 13,
                        ),
                        AddressField(
                          addressCtrl: account.addressCtrl,
                          detailAddressCtrl: account.detailAddressCtrl,
                        ),
                      ],
                    ),
                    Column(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("로그인 초대숫자를 적어주세요.",
                            style:
                                MyTypo.title2.copyWith(color: MyColor.grey800)),
                        CustomTextField(
                          controller: account.inviteCodeCtrl,
                          hintText: "7자리 친숙한 숫자 입력",
                          validator: (value) =>
                              Validators.chainValidators(value, [
                            (value) =>
                                Validators.emptyValidator(value, data: "초대숫자를"),
                            (value) {
                              if (value!.length != 7) {
                                return "초대숫자는 7자리로 입력해주세요.";
                              }
                              return null;
                            },
                          ]),
                          title: "부모님께서 기억하시기에\n친숙한 숫자를 적어주시면 좋아요!",
                          keyboardType: TextInputType.number,
                          inputAction: TextInputAction.done,
                          maxLength: 7,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: removeAccount,
                          child: Text(
                            "삭제",
                            style: MyTypo.button.copyWith(color: MyColor.red),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (account.formKey.currentState?.validate() ==
                                true) {
                              setMode(InputMode.open);
                            }
                          },
                          child: Text(
                            "저장하기",
                            style: MyTypo.button.copyWith(
                              color: MyColor.grey500,
                              decoration: TextDecoration.underline,
                              decorationColor: MyColor.grey500,
                              decorationThickness: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      case InputMode.open:
        final info = {
          "이름": account.nameCtrl.text,
          "연락처": account.phoneNumberCtrl.text,
          "집주소": account.addressCtrl.text +
              (account.detailAddressCtrl.text.isNotEmpty
                  ? " ${account.detailAddressCtrl.text}"
                  : ""),
          "출생연도": account.birthDateCtrl.text,
          "초대숫자": account.inviteCodeCtrl.text,
        };
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
          decoration: BoxDecoration(
            color: MyColor.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [MyEffects.shadow],
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setMode(InputMode.close);
                },
                behavior: HitTestBehavior.translucent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${account.nameCtrl.text} 님의 정보",
                        style: MyTypo.title2.copyWith(color: MyColor.grey800)),
                    SvgPicture.asset(
                      "assets/icons/ic_12_chevron_up.svg",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, idx) => _buildRow(
                    info.keys.elementAt(idx), info.values.elementAt(idx)),
                separatorBuilder: (context, idx) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(color: MyColor.grey300, height: 0.5),
                ),
                itemCount: info.length,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: removeAccount,
                      child: Text("삭제",
                          style: MyTypo.helper.copyWith(color: MyColor.red))),
                  GestureDetector(
                    onTap: () {
                      setMode(InputMode.edit);
                    },
                    child: Text(
                      "수정하기",
                      style: MyTypo.helper.copyWith(
                        color: MyColor.grey500,
                        decoration: TextDecoration.underline,
                        decorationColor: MyColor.grey500,
                        decorationThickness: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      case InputMode.close:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
          decoration: BoxDecoration(
            color: MyColor.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [MyEffects.shadow],
          ),
          child: GestureDetector(
            onTap: () {
              setMode(InputMode.open);
            },
            behavior: HitTestBehavior.translucent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${account.nameCtrl.text} 님의 정보",
                    style: MyTypo.title2.copyWith(color: MyColor.grey800)),
                SvgPicture.asset(
                  "assets/icons/ic_12_chevron_down.svg",
                ),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildRow(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: MyTypo.subTitle2.copyWith(color: MyColor.grey600)),
          Expanded(
            child: Text(
              content,
              style: MyTypo.body1.copyWith(color: MyColor.grey900),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
