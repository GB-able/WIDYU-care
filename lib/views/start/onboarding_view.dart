import 'dart:ui';
import 'package:care/models/enums/social_type.dart';
import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:care/views/start/widgets/social_btn.dart';
import 'package:care/widgets/text_btn.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  List<String> descriptions =
      List.generate(5, (_) => "부모님의 하루를 챙기고,\n마음까지 전하세요.");
  final _ctrl = CarouselSliderController();
  int _currIdx = 0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
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
                      carouselController: _ctrl,
                      itemCount: descriptions.length,
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
                          setState(() {
                            _currIdx = index;
                          });
                        },
                      ),
                      itemBuilder: (context, index, realIndex) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Image.asset(
                                  "assets/images/img_300_onboarding_1.png",
                                  height: double.infinity,
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            Text(
                              descriptions[index],
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
                  descriptions.length,
                  (index) => Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          _currIdx == index ? MyColor.grey500 : MyColor.grey100,
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
                  SocialBtn(type: SocialType.naver, onTap: () {}),
                  SocialBtn(type: SocialType.kakao, onTap: () {}),
                  SocialBtn(type: SocialType.apple, onTap: () {}),
                  TextBtn(text: "이메일로 시작하기", enable: true, onTap: () {})
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
