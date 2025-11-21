import 'package:care/styles/colors.dart';
import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage(
      {super.key,
      required this.url,
      required this.width,
      required this.height});

  final String url;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        height: width,
        width: height,
        color: MyColor.grey100,
        child: const Icon(
          Icons.image,
          color: MyColor.grey300,
          size: 48,
        ),
      ),
    );
  }
}
