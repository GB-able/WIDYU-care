import 'package:care/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key, required this.profileImage, this.size = 32});

  final String? profileImage;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (profileImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: CustomNetworkImage(
          url: profileImage!,
          width: size,
          height: size,
        ),
      );
    } else {
      return Image.asset("assets/images/img_32_profile_empty.png", width: size);
    }
  }
}
