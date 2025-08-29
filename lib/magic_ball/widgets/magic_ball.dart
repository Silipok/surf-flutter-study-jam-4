import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magic_8_ball/magic_ball/bloc/magic_ball_bloc.dart';
import 'package:magic_8_ball/utils/images.dart';

class MagicBall extends StatefulWidget {
  const MagicBall({super.key});

  @override
  State<MagicBall> createState() => _MagicBallState();
}

class _MagicBallState extends State<MagicBall>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _pulsatingController;
  late AnimationController _textController;
  late AnimationController _thinkingController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulsatingAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _textScaleAnimation;
  
  int _thinkingTextIndex = 0;
  final List<String> _thinkingTexts = [
    'Думаю...',
    'Размышляю...',
    'Консультируюсь\nс космосом...',
    'Почти готово...',
  ];

  @override
  void initState() {
    super.initState();
    
    // Floating animation - smooth up and down movement
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _floatingAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));
    
    // Pulsating animation for loading state
    _pulsatingController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pulsatingAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulsatingController,
      curve: Curves.easeInOut,
    ));
    
    // Text appearance animation
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));
    _textScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    ));
    
    // Thinking text animation - cycles through different texts
    _thinkingController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Start floating animation
    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _pulsatingController.dispose();
    _textController.dispose();
    _thinkingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MagicBallBloc, MagicBallState>(
      listener: (context, state) {
        // Start/stop animations based on state
        if (state.status == MagicBallStatus.loading) {
          _pulsatingController.repeat(reverse: true);
          _textController.reset();
          _startThinkingAnimation();
        } else {
          _pulsatingController.stop();
          _pulsatingController.reset();
          _thinkingController.stop();
          _thinkingController.reset();
          
          // Start text animation when answer is loaded
          if (state.status == MagicBallStatus.loaded || 
              state.status == MagicBallStatus.error) {
            _textController.forward();
          }
        }
      },
      child: BlocBuilder<MagicBallBloc, MagicBallState>(
        builder: (context, state) {
          return AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatingAnimation.value),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Magic Ball with Shadow
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Colored Shadow
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _getShadowColor(state.status),
                                blurRadius: 20,
                                spreadRadius: 5,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                        ),
                        
                        // Pulsating wrapper for loading state
                        AnimatedBuilder(
                          animation: _pulsatingAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: state.status == MagicBallStatus.loading 
                                  ? _pulsatingAnimation.value 
                                  : 1.0,
                              child: child,
                            );
                          },
                          child: GestureDetector(
                            onTap: () {
                              if (state.status != MagicBallStatus.loading) {
                                context.read<MagicBallBloc>().add(GetPrediction());
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Glowing rim effect
                                Container(
                                  width: 220,
                                  height: 220,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        Colors.transparent,
                                        _getRimColor(state.status).withOpacity(0.8),
                                      ],
                                      stops: const [0.85, 1.0],
                                    ),
                                  ),
                                ),
                                
                                // Main magic ball
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Base ball image
                                    Container(
                                      width: 200,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: [
                                            const Color(0xFF2D1B69),
                                            const Color(0xFF1A0E3D),
                                            const Color(0xFF0A0A0A),
                                          ],
                                          stops: const [0.0, 0.7, 1.0],
                                        ),
                                      ),
                                    ),
                                    
                                    // Starfield layer
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Container(
                                        width: 200,
                                        height: 200,
                                        child: _buildStarfield(),
                                      ),
                                    ),
                                    
                                    // State overlays
                                    if (state.status == MagicBallStatus.loading)
                                      Container(
                                        width: 200,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black.withOpacity(0.8),
                                        ),
                                      ),
                                    
                                    if (state.status == MagicBallStatus.error)
                                      Container(
                                        width: 200,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            colors: [
                                              Colors.red.withOpacity(0.2),
                                              Colors.red.withOpacity(0.7),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                
                                // Thinking text instead of loading indicator
                                if (state.status == MagicBallStatus.loading)
                                  AnimatedBuilder(
                                    animation: _thinkingController,
                                    builder: (context, child) {
                                      return Container(
                                        width: 150,
                                        padding: const EdgeInsets.all(16),
                                        child: Text(
                                          _thinkingTexts[_thinkingTextIndex],
                                          style: TextStyle(
                                            color: Colors.cyan.withOpacity(0.9),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            shadows: [
                                              Shadow(
                                                color: Colors.cyan.withOpacity(0.5),
                                                offset: const Offset(0, 0),
                                                blurRadius: 8,
                                              ),
                                              const Shadow(
                                                color: Colors.black,
                                                offset: Offset(1, 1),
                                                blurRadius: 2,
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    },
                                  )
                                
                                // Answer text with animation
                                else if (state.status == MagicBallStatus.loaded ||
                                         state.status == MagicBallStatus.error)
                                  AnimatedBuilder(
                                    animation: _textController,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _textScaleAnimation.value,
                                        child: Opacity(
                                          opacity: _textOpacityAnimation.value,
                                          child: Container(
                                            width: 150,
                                            padding: const EdgeInsets.all(16),
                                            child: Text(
                                              state.message ?? '',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.cyan,
                                                    offset: Offset(0, 0),
                                                    blurRadius: 4,
                                                  ),
                                                  Shadow(
                                                    color: Colors.black,
                                                    offset: Offset(1, 1),
                                                    blurRadius: 2,
                                                  ),
                                                ],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getShadowColor(MagicBallStatus status) {
    switch (status) {
      case MagicBallStatus.loading:
        return Colors.blue.withOpacity(0.6);
      case MagicBallStatus.loaded:
        return Colors.purple.withOpacity(0.6);
      case MagicBallStatus.error:
        return Colors.red.withOpacity(0.6);
      case MagicBallStatus.initial:
        return Colors.cyan.withOpacity(0.4);
    }
  }

  Color _getRimColor(MagicBallStatus status) {
    switch (status) {
      case MagicBallStatus.loading:
        return Colors.blue;
      case MagicBallStatus.loaded:
        return Colors.cyan;
      case MagicBallStatus.error:
        return Colors.red;
      case MagicBallStatus.initial:
        return Colors.cyan;
    }
  }

  void _startThinkingAnimation() {
    _thinkingTextIndex = 0;
    _thinkingController.repeat();
    
    // Change thinking text every 600ms
    Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (mounted && _thinkingController.isAnimating) {
        setState(() {
          _thinkingTextIndex = (_thinkingTextIndex + 1) % _thinkingTexts.length;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Widget _buildStarfield() {
    return Container(
      width: 200,
      height: 200,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: CustomPaint(
        painter: StarfieldPainter(),
      ),
    );
  }
}

/// Custom painter for creating the starfield effect
class StarfieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Generate stars at fixed positions for consistency - more prominent like Figma
    final stars = [
      // Large bright stars - main focal points
      {'x': 0.3, 'y': 0.25, 'size': 4.0, 'opacity': 1.0},
      {'x': 0.7, 'y': 0.35, 'size': 3.5, 'opacity': 0.9},
      {'x': 0.2, 'y': 0.65, 'size': 3.0, 'opacity': 0.8},
      {'x': 0.8, 'y': 0.7, 'size': 3.5, 'opacity': 0.9},
      {'x': 0.5, 'y': 0.5, 'size': 2.5, 'opacity': 0.7}, // Center star
      
      // Medium stars - supporting elements
      {'x': 0.15, 'y': 0.4, 'size': 2.0, 'opacity': 0.8},
      {'x': 0.85, 'y': 0.5, 'size': 2.0, 'opacity': 0.8},
      {'x': 0.4, 'y': 0.15, 'size': 2.2, 'opacity': 0.7},
      {'x': 0.6, 'y': 0.8, 'size': 2.2, 'opacity': 0.7},
      {'x': 0.45, 'y': 0.7, 'size': 1.8, 'opacity': 0.6},
      
      // Small stars - fill the space
      {'x': 0.25, 'y': 0.5, 'size': 1.5, 'opacity': 0.7},
      {'x': 0.75, 'y': 0.6, 'size': 1.5, 'opacity': 0.7},
      {'x': 0.55, 'y': 0.3, 'size': 1.8, 'opacity': 0.6},
      {'x': 0.35, 'y': 0.75, 'size': 1.5, 'opacity': 0.6},
      {'x': 0.65, 'y': 0.2, 'size': 1.5, 'opacity': 0.6},
      {'x': 0.1, 'y': 0.6, 'size': 1.2, 'opacity': 0.5},
      {'x': 0.9, 'y': 0.3, 'size': 1.2, 'opacity': 0.5},
      
      // Tiny sparkles - ambient effect
      {'x': 0.12, 'y': 0.3, 'size': 1.0, 'opacity': 0.5},
      {'x': 0.88, 'y': 0.4, 'size': 1.0, 'opacity': 0.5},
      {'x': 0.32, 'y': 0.85, 'size': 1.0, 'opacity': 0.5},
      {'x': 0.72, 'y': 0.15, 'size': 1.0, 'opacity': 0.5},
      {'x': 0.58, 'y': 0.6, 'size': 0.8, 'opacity': 0.4},
      {'x': 0.42, 'y': 0.4, 'size': 0.8, 'opacity': 0.4},
    ];

    for (final star in stars) {
      final x = (star['x']! as double) * size.width;
      final y = (star['y']! as double) * size.height;
      final starSize = star['size']! as double;
      final opacity = star['opacity']! as double;
      
      // Check if star is within circle bounds
      final distance = (Offset(x, y) - center).distance;
      if (distance <= radius - 15) {
        // Draw star glow first (larger, softer)
        if (starSize > 1.5) {
          paint.color = Colors.white.withOpacity(opacity * 0.3);
          canvas.drawCircle(Offset(x, y), starSize * 2.5, paint);
        }
        
        // Draw main star body
        paint.color = Colors.white.withOpacity(opacity);
        canvas.drawCircle(Offset(x, y), starSize, paint);
        
        // Add bright center for larger stars
        if (starSize > 2.5) {
          paint.color = Colors.white;
          canvas.drawCircle(Offset(x, y), starSize * 0.4, paint);
          
          // Add colored sparkle for very large stars
          paint.color = Colors.cyan.withOpacity(0.8);
          canvas.drawCircle(Offset(x, y), starSize * 0.2, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
