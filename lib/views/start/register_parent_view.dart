import 'package:care/models/constants/route_name.dart';
import 'package:care/providers/user_provider.dart';
import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:care/views/start/register_parent_view_model.dart';
import 'package:care/views/start/widgets/parent_info_fields.dart';
import 'package:care/views/start/widgets/start_progress_bar.dart';
import 'package:care/widgets/custom_app_bar.dart';
import 'package:care/widgets/text_btn.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterParentView extends StatelessWidget {
  const RegisterParentView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterParentViewModel(),
      child: Consumer2<UserProvider, RegisterParentViewModel>(
        builder: (context, userProvider, viewModel, child) {
          return Scaffold(
            appBar: CustomAppBar(
              onBack: () {
                userProvider.previousStep();
              },
            ),
            body: Column(
              children: [
                const StartProgressBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 28, 16,
                          60 + MediaQuery.of(context).padding.bottom),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            spacing: 60,
                            children: viewModel.accounts
                                .mapIndexed(
                                  (idx, account) => ParentInfoFields(
                                    mode: viewModel.modes[idx],
                                    account: account,
                                    removeAccount: () {
                                      viewModel.removeAccount(idx);
                                    },
                                    setMode: (mode) {
                                      viewModel.setMode(idx, mode);
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 60),
                          GestureDetector(
                            onTap: () {
                              viewModel.addAccount();
                            },
                            child: Row(
                              spacing: 5,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset("assets/icons/ic_24_plus.svg"),
                                Text(
                                  "부모님 추가하기",
                                  style: MyTypo.button.copyWith(
                                    color: MyColor.primary,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 60),
                          TextBtn(
                            onTap: () async {
                              if (await viewModel.register()) {
                                // [TODO] 부모님 생성 실패 로직 넣기
                                if (context.mounted) {
                                  userProvider.nextStep();
                                  context.go(RouteName.welcome);
                                }
                              }
                            },
                            text: "완료",
                            enable: viewModel.modes.every(
                              (mode) => mode != InputMode.edit,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
