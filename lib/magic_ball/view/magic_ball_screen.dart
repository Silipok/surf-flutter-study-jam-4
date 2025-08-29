import 'package:flutter/material.dart';
import 'package:magic_8_ball/magic_ball/widgets/ball_platform.dart';
import 'package:magic_8_ball/magic_ball/widgets/magic_ball.dart';

class MagicBallScreen extends StatelessWidget {
  const MagicBallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTabletOrDesktop = screenWidth > 600;
    final isLandscape = screenWidth > screenHeight;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF110D2D), Color(0xFF010103)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isTabletOrDesktop
            ? _buildTabletDesktopLayout(context, isLandscape)
            : _buildMobileLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(
          flex: 3,
          child: Center(child: MagicBall()),
        ),
        const Expanded(
          flex: 1,
          child: BallPlatform(),
        ),
        // Bottom instruction text
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            'Нажмите на шар\nили потрясите телефон',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTabletDesktopLayout(BuildContext context, bool isLandscape) {
    if (isLandscape) {
      // Landscape layout for tablets/desktop
      return Row(
        children: [
          const Expanded(
            flex: 2,
            child: Center(child: MagicBall()),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Magic 8-Ball',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Think of a question and tap the ball\nor shake your device!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                const BallPlatform(),
              ],
            ),
          ),
        ],
      );
    } else {
      // Portrait layout for tablets
      return Column(
        children: [
          const Expanded(
            flex: 1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Magic 8-Ball',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Think of a question and tap the ball or shake your device!',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const Expanded(
            flex: 2,
            child: Center(child: MagicBall()),
          ),
          const Expanded(
            flex: 1,
            child: BallPlatform(),
          ),
        ],
      );
    }
  }
}
