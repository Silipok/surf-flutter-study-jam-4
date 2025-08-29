part of 'magic_ball_bloc.dart';

abstract class MagicBallEvent extends Equatable {
  const MagicBallEvent();

  @override
  List<Object> get props => [];
}

class GetPrediction extends MagicBallEvent {}
