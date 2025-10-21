import 'dart:ui';
import 'package:care/models/constants/route_name.dart';
import 'package:care/models/enums/social_type.dart';
import 'package:care/providers/user_provider.dart';
import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:care/views/start/join_view_model.dart';
import 'package:care/views/start/onboarding_view_model.dart';
import 'package:care/views/start/widgets/social_btn.dart';
import 'package:care/widgets/text_btn.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingViewModel(),
      child: Consumer2<OnboardingViewModel, UserProvider>(
        builder: (context, viewModel, userProvider, _) =>
            AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFFFFBF1),
                                Color(0xFFFFD0CA),
                                Color(0xFFFFFFFF),
                              ],
                              stops: [0, 0.8, 1],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top + 40),
                        child: CarouselSlider.builder(
                          carouselController: viewModel.ctrl,
                          itemCount: viewModel.descriptions.length,
                          options: CarouselOptions(
                            height: double.infinity,
                            viewportFraction: 1.0,
                            enableInfiniteScroll: true,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 5),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            onPageChanged: (index, reason) {
                              viewModel.setCurrIdx(index);
                            },
                          ),
                          itemBuilder: (context, index, realIndex) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Image.asset(
                                      "assets/images/img_300_onboarding_1.png",
                                      height: double.infinity,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                Text(
                                  viewModel.descriptions[index],
                                  style: MyTypo.title2
                                      .copyWith(color: MyColor.grey800),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10)
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32, bottom: 24),
                  child: Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      viewModel.descriptions.length,
                      (index) => Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: viewModel.currIdx == index
                              ? MyColor.grey500
                              : MyColor.grey100,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      16, 0, 16, 16 + MediaQuery.of(context).padding.bottom),
                  child: Column(
                    spacing: 8,
                    children: [
                      SocialBtn(
                          type: SocialType.naver,
                          onTap: () async {
                            viewModel.socialLogin(SocialType.naver, (profile) {
                              context.push(RouteName.integrate, extra: {
                                "profile": profile,
                                "provider": SocialType.naver,
                              });
                            }, () async {
                              await userProvider.init();
                              if (context.mounted) {
                                if (userProvider.profile == null) {
                                  return;
                                }
                                if (userProvider.profile!.hasParents) {
                                  context.push(RouteName.home);
                                } else {
                                  context.push(RouteName.join,
                                      extra: JoinStatus.welcomeInvite);
                                }
                              }
                            });
                          }),
                      SocialBtn(
                          type: SocialType.kakao,
                          onTap: () async {
                            viewModel.socialLogin(
                              SocialType.kakao,
                              (profile) {
                                context.push(RouteName.integrate, extra: {
                                  "profile": profile,
                                  "provider": SocialType.kakao,
                                });
                              },
                              () async {
                                await userProvider.init();
                                if (userProvider.profile == null ||
                                    !context.mounted) {
                                  return;
                                }
                                if (userProvider.profile!.hasParents) {
                                  context.push(RouteName.home);
                                } else {
                                  context.push(RouteName.join,
                                      extra: JoinStatus.welcomeInvite);
                                }
                              },
                            );
                          }),
                      SocialBtn(
                          type: SocialType.apple,
                          onTap: () async {
                            viewModel.socialLogin(
                              SocialType.apple,
                              (profile) {
                                context.push(RouteName.integrate, extra: {
                                  "profile": profile,
                                  "provider": SocialType.apple,
                                });
                              },
                              () async {
                                await userProvider.init();
                                if (userProvider.profile == null ||
                                    !context.mounted) {
                                  return;
                                }
                                if (userProvider.profile!.hasParents) {
                                  context.push(RouteName.home);
                                } else if (userProvider.profile!.phoneNumber ==
                                    null) {
                                  context.push(RouteName.join,
                                      extra: JoinStatus.applePhone);
                                } else {
                                  context.push(RouteName.join,
                                      extra: JoinStatus.welcomeInvite);
                                }
                              },
                            );
                          }),
                      TextBtn(
                        text: "이메일로 계속하기",
                        enable: true,
                        onTap: () {
                          context.push(RouteName.login);
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
