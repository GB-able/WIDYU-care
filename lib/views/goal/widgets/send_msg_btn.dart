import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:care/widgets/icon_widget.dart';
import 'package:flutter/material.dart';

class SendMsgBtn extends StatelessWidget {
  const SendMsgBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        showModalBottomSheet(
          useRootNavigator: true,
          isScrollControlled: true,
          context: context,
          builder: (context) => Container(
            decoration: const BoxDecoration(
              color: MyColor.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.fromLTRB(
                16, 32, 16, 64 + MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("응원 메시지 보내기", style: MyTypo.title3),
                const SizedBox(height: 20),
                const SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 12,
                    children: [
                      MsgTextField(text: "약 복용 하실 시간이에요. 화이팅 하세요!"),
                      MsgTextField(text: "오늘 많이 안걸으셨네요. 조금만 더 화이팅!"),
                      MsgTextField(text: "건강 방문 일정 잊지 않으셨죠?"),
                      MsgTextField(text: "오늘 목표도 화이팅 하세요!"),
                      MsgTextField(text: null),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.of(context).size.width - 40, 56),
        backgroundColor: MyColor.primary,
        foregroundColor: MyColor.primary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      label: Text("응원 메시지 보내기",
          style: MyTypo.title3.copyWith(color: MyColor.white)),
      icon: const IconWidget(
        icon: "send",
        width: 20,
        height: 20,
        color: MyColor.white,
      ),
      iconAlignment: IconAlignment.end,
    );
  }
}

class MsgTextField extends StatefulWidget {
  const MsgTextField({super.key, required this.text});

  final String? text;

  @override
  State<MsgTextField> createState() => _MsgTextFieldState();
}

class _MsgTextFieldState extends State<MsgTextField> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.text ?? "";
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Expanded(
          child: Stack(
            children: [
              TextField(
                controller: controller,
                style: MyTypo.body2,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 9.5),
                  hintText: widget.text ?? "직접 입력...",
                  hintStyle: MyTypo.hint.copyWith(color: MyColor.grey300),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: MyColor.grey300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabled: widget.text == null,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: MyColor.grey300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: MyColor.grey800),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIconConstraints:
                      const BoxConstraints(minWidth: 0, minHeight: 0),
                  suffixIcon: widget.text == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Text("${controller.text.length}/50",
                                  style: MyTypo.helper
                                      .copyWith(color: MyColor.grey600)),
                            ),
                          ],
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: MyColor.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const IconWidget(
              icon: "send",
              width: 20,
              height: 20,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
    ;
  }
}
