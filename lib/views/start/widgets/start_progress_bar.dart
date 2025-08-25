import 'package:care/providers/user_provider.dart';
import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_progress/step_progress.dart';

class StartProgressBar extends StatelessWidget {
  const StartProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => StepProgress(
        totalSteps: 3,
        currentStep: userProvider.joinStep,
        padding: const EdgeInsets.fromLTRB(34, 6, 34, 0),
        stepSize: 19,
        nodeTitles: const ["케어러 정보", "부모님 정보", "완료"],
        nodeIconBuilder: (index, completedStepIndex) {
          if (index < completedStepIndex) {
            return Container(
              width: 15,
              height: 15,
              margin: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: MyColor.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                size: 11,
                color: MyColor.white,
              ),
            );
          } else if (index == completedStepIndex) {
            return Container(
              width: 19,
              height: 19,
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: MyColor.primary,
                    blurRadius: 6,
                    blurStyle: BlurStyle.normal,
                  )
                ],
              ),
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: MyColor.primary,
                  shape: BoxShape.circle,
                ),
              ),
            );
          } else {
            return Container(
              width: 19,
              height: 19,
              margin: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: MyColor.grey300,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }
        },
        theme: StepProgressThemeData(
          activeForegroundColor: Colors.transparent,
          defaultForegroundColor: Colors.transparent,
          stepNodeStyle: const StepNodeStyle(
            shape: StepNodeShape.circle,
            icon: null,
            iconColor: Colors.transparent,
          ),
          stepLineStyle: const StepLineStyle(
            lineThickness: 1,
            activeColor: MyColor.primary,
            foregroundColor: MyColor.grey300,
          ),
          nodeLabelAlignment: StepLabelAlignment.bottom,
          nodeLabelStyle: StepLabelStyle(
            activeColor: MyColor.primary,
            defualtColor: MyColor.grey300,
            maxWidth: 64,
            titleStyle: MyTypo.helper2,
            margin: const EdgeInsets.only(top: 5),
          ),
        ),
      ),
    );
  }
}
