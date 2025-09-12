import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:care/views/find/find_email_view_model.dart';
import 'package:care/widgets/account_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailSuccess extends StatelessWidget {
  const EmailSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FindEmailViewModel>(
      builder: (context, viewModel, _) => Column(
        children: [
          const SizedBox(height: 9),
          Text("이메일 찾기", style: MyTypo.title2.copyWith(color: MyColor.grey800)),
          Text("아이디를 찾기 위한 정보를 입력해 주세요.",
              style: MyTypo.body2.copyWith(color: MyColor.grey600)),
          const SizedBox(height: 32),
          AccountInfo(
            type: AccountInfoType.find,
            name: viewModel.profile!.name,
            phone: viewModel.profile!.phoneNumber!,
            email: viewModel.profile!.email,
          ),
        ],
      ),
    );
  }
}
