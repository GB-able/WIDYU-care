import 'package:care/views/find/find_email_view_model.dart';
import 'package:care/views/find/widgets/email_btns.dart';
import 'package:care/views/find/widgets/email_identity.dart';
import 'package:care/views/find/widgets/email_refind.dart';
import 'package:care/views/find/widgets/email_success.dart';
import 'package:care/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FindEmailView extends StatelessWidget {
  const FindEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FindEmailViewModel(),
      child: Consumer<FindEmailViewModel>(
        builder: (context, viewModel, _) => Scaffold(
          appBar: const CustomAppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 60),
              child: switch (viewModel.findStatus) {
                FindEmailStatus.identity => const EmailIdentity(),
                FindEmailStatus.success => const EmailSuccess(),
                FindEmailStatus.fail => const EmailRefind(),
              },
            ),
          ),
          bottomNavigationBar: const EmailBtns(),
        ),
      ),
    );
  }
}
