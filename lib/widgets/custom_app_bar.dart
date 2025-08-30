import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key, this.title = "", this.canBack = true, this.onBack});

  final String title;
  final bool canBack;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MyColor.white,
      automaticallyImplyLeading: false,
      leadingWidth: 32,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: canBack
            ? GestureDetector(
                onTap: () {
                  onBack?.call();
                  context.pop();
                },
                child: SvgPicture.asset(
                  "assets/icons/ic_22_chevron_left.svg",
                  width: 22,
                  height: 22,
                ),
              )
            : const SizedBox.shrink(),
      ),
      title: title.isNotEmpty
          ? Text(title, style: MyTypo.title3.copyWith(color: MyColor.grey800))
          : null,
      centerTitle: true,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(44.0);
}
