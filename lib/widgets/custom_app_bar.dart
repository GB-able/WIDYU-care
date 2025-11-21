import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

enum CustomAppBarType {
  small,
  large,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title = "",
    this.canBack = true,
    this.onBack,
    this.type = CustomAppBarType.small,
    this.actions,
  });

  final String title;
  final bool canBack;
  final VoidCallback? onBack;
  final CustomAppBarType type;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MyColor.white,
      automaticallyImplyLeading: false,
      leadingWidth: 38,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: canBack
            ? GestureDetector(
                onTap: () {
                  onBack?.call();
                  context.pop();
                },
                child: SvgPicture.asset(
                  "assets/icons/ic_22_back.svg",
                  width: 22,
                  height: 22,
                  colorFilter:
                      const ColorFilter.mode(MyColor.grey600, BlendMode.srcIn),
                ),
              )
            : const SizedBox.shrink(),
      ),
      actions: actions,
      actionsPadding: const EdgeInsets.only(right: 16),
      title: title.isNotEmpty
          ? Text(title, style: MyTypo.title3.copyWith(color: MyColor.grey800))
          : null,
      centerTitle: true,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(type == CustomAppBarType.small ? 44 : 52);
}
