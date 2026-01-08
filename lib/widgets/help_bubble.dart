import 'dart:math';

import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:flutter/material.dart';

class HelpBubble extends StatelessWidget {
  const HelpBubble({super.key, required this.txt});

  final String txt;

  @override
  Widget build(BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: txt,
        style: MyTypo.helper3.copyWith(color: MyColor.white),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    const horizontalPadding = 12.0;
    const verticalPadding = 8.0;
    const tailWidth = 16.0;
    const tailHeight = 9.0;

    final bubbleWidth =
        max(textPainter.width, tailWidth) + horizontalPadding * 2;
    final bubbleHeight = textPainter.height + verticalPadding * 2 + tailHeight;
    return CustomPaint(
      size: Size(bubbleWidth, bubbleHeight),
      painter: _HelpBubblePainter(
        txt: txt,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        tailWidth: tailWidth,
        tailHeight: tailHeight,
        textPainter: textPainter,
      ),
    );
  }
}

class _HelpBubblePainter extends CustomPainter {
  final String txt;
  final double horizontalPadding;
  final double verticalPadding;
  final double tailWidth;
  final double tailHeight;
  final TextPainter textPainter;
  _HelpBubblePainter({
    required this.txt,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.tailWidth,
    required this.tailHeight,
    required this.textPainter,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bodyRect = Rect.fromLTWH(
      0,
      tailHeight,
      size.width,
      size.height - tailHeight,
    );
    const tailRadius = 2.0;
    final midX = size.width / 2;
    final baseLeftX = midX - tailWidth / 2;
    final baseRightX = midX + tailWidth / 2;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(bodyRect, const Radius.circular(8)))
      ..addPath(
        Path()
          ..moveTo(baseLeftX, tailHeight)
          ..lineTo(midX - tailRadius, tailRadius)
          ..quadraticBezierTo(midX, 0, midX + tailRadius, tailRadius)
          ..lineTo(baseRightX, tailHeight)
          ..close(),
        Offset.zero,
      );
    canvas.drawPath(path, Paint()..color = MyColor.grey900);
    textPainter.paint(
        canvas, Offset(horizontalPadding, tailHeight + verticalPadding));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! _HelpBubblePainter) {
      return true;
    }
    return oldDelegate.txt != txt ||
        oldDelegate.horizontalPadding != horizontalPadding ||
        oldDelegate.verticalPadding != verticalPadding ||
        oldDelegate.tailHeight != tailHeight;
  }
}
