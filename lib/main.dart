import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magic_8_ball/magic_ball/bloc/magic_ball_bloc.dart';
import 'package:magic_8_ball/magic_ball/view/magic_ball_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

/// App,s main widget.
class MyApp extends StatelessWidget {
  /// Constructor for [MyApp].
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),
      home: BlocProvider(
        create: (context) => MagicBallBloc(),
        child: const MagicBallScreen(),
      ),
    );
  }
}
