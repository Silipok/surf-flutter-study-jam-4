import 'package:flutter/material.dart';
import 'package:magic_8_ball/utils/images.dart';

class BallPlatform extends StatelessWidget {
  const BallPlatform({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(Images.ellipse),
        Image.asset(Images.smoke),
      ],
    );
  }
}
