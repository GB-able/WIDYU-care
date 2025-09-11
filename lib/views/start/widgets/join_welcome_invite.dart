import 'package:care/providers/user_provider.dart';
import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:care/views/start/join_view_model.dart';
import 'package:care/widgets/account_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoinWelcomeInvite extends StatelessWidget {
  const JoinWelcomeInvite({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<JoinViewModel, UserProvider>(
      builder: (context, viewModel, userProvider, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 27),
            child: Text("환영해요, 보호자님!",
                style: MyTypo.title2.copyWith(color: MyColor.grey800)),
          ),
          AccountInfo(
            type: AccountInfoType.notice,
            name: userProvider.profile!.name,
            phone: userProvider.profile!.phoneNumber ?? "",
            email: userProvider.profile!.email,
          ),
        ],
      ),
    );
  }
}
