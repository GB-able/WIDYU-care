import 'package:care/models/constants/route_name.dart';
import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class BotNav extends StatefulWidget {
  const BotNav({super.key});

  @override
  State<BotNav> createState() => _BotNavState();
}

class _BotNavState extends State<BotNav> {
  int _currentIndex = 0;

  void setIdx(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54 + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        color: MyColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(8, 0),
          ),
        ],
      ),
      child: BottomNavigationBar(
        elevation: 0,
        currentIndex: _currentIndex,
        onTap: (index) {
          setIdx(index);
          switch (index) {
            case 0:
              context.go(RouteName.home);
              break;
            case 1:
              context.go(RouteName.goal);
              break;
            case 2:
              context.go(RouteName.location);
              break;
            case 3:
              context.go(RouteName.album);
              break;
            case 4:
              context.go(RouteName.user);
              break;
          }
        },
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: MyColor.grey700,
        unselectedItemColor: MyColor.grey400,
        selectedLabelStyle: MyTypo.helper.copyWith(color: MyColor.grey700),
        unselectedLabelStyle: MyTypo.helper.copyWith(color: MyColor.grey400),
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/ic_24_home.svg"),
            activeIcon: SvgPicture.asset(
              "assets/icons/ic_24_home.svg",
              colorFilter:
                  const ColorFilter.mode(MyColor.grey800, BlendMode.srcIn),
            ),
            label: "홈",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/ic_24_health.svg"),
            activeIcon: SvgPicture.asset(
              "assets/icons/ic_24_health.svg",
              colorFilter:
                  const ColorFilter.mode(MyColor.grey800, BlendMode.srcIn),
            ),
            label: "목표",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/ic_24_location.svg"),
            activeIcon: SvgPicture.asset(
              "assets/icons/ic_24_location.svg",
              colorFilter:
                  const ColorFilter.mode(MyColor.grey800, BlendMode.srcIn),
            ),
            label: "위치",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/ic_24_album.svg"),
            activeIcon: SvgPicture.asset(
              "assets/icons/ic_24_album.svg",
              colorFilter:
                  const ColorFilter.mode(MyColor.grey800, BlendMode.srcIn),
            ),
            label: "앨범",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/ic_24_user.svg"),
            activeIcon: SvgPicture.asset(
              "assets/icons/ic_24_user.svg",
              colorFilter:
                  const ColorFilter.mode(MyColor.grey800, BlendMode.srcIn),
            ),
            label: "내정보",
          ),
        ],
      ),
    );
  }
}
