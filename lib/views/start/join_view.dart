import 'package:care/views/start/join_view_model.dart';
import 'package:care/views/start/widgets/join_btns.dart';
import 'package:care/views/start/widgets/join_welcome_invite.dart';
import 'package:care/views/start/widgets/join_email_password.dart';
import 'package:care/views/start/widgets/join_identity_verification.dart';
import 'package:care/views/start/widgets/start_progress_bar.dart';
import 'package:care/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoinView extends StatelessWidget {
  const JoinView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => JoinViewModel(),
      child: Consumer<JoinViewModel>(
        builder: (context, viewModel, _) => Scaffold(
          appBar: CustomAppBar(
              canBack: viewModel.joinStatus != JoinStatus.welcomeInvite),
          body: Column(
            children: [
              const StartProgressBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: switch (viewModel.joinStatus) {
                      JoinStatus.identityVerification =>
                        const JoinIdentityVerification(),
                      JoinStatus.emailPassword => const JoinEmailPassword(),
                      JoinStatus.welcomeInvite => const JoinWelcomeInvite(),
                    },
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: const JoinBtns(),
        ),
      ),
    );
  }
}
