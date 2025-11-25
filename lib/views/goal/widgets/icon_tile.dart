import 'package:care/styles/colors.dart';
import 'package:flutter/material.dart';

enum IconTileType { pill, walk, hospital }

class IconTile extends StatelessWidget {
  const IconTile({super.key, required this.type});

  final IconTileType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: MyColor.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 5,
              offset: const Offset(1, 1))
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          "assets/images/img_40_${type.name}.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
