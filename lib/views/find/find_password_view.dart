import 'package:care/views/find/find_password_view_model.dart';
import 'package:care/views/find/widgets/password_btns.dart';
import 'package:care/views/find/widgets/password_identify.dart';
import 'package:care/views/find/widgets/password_refind.dart';
import 'package:care/views/find/widgets/password_reset.dart';
import 'package:care/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FindPasswordView extends StatelessWidget {
  const FindPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FindPasswordViewModel(),
      child: Consumer<FindPasswordViewModel>(
        builder: (context, viewModel, _) => Scaffold(
          appBar: const CustomAppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 60),
              child: switch (viewModel.findStatus) {
                FindPasswordStatus.identity => const PasswordIdentify(),
                FindPasswordStatus.success => const PasswordReset(),
                FindPasswordStatus.fail => const PasswordRefind(),
              },
            ),
          ),
          bottomNavigationBar: const PasswordBtns(),
        ),
      ),
    );
  }
}
