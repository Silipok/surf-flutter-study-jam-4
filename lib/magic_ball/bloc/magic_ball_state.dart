part of 'magic_ball_bloc.dart';

enum MagicBallStatus {
  initial,
  loading,
  loaded,
  error,
}

class MagicBallState extends Equatable {
  const MagicBallState({
    this.status = MagicBallStatus.initial,
    this.message,
  });

  final MagicBallStatus status;
  final String? message;

  MagicBallState copyWith({
    MagicBallStatus? status,
    String? message,
  }) {
    return MagicBallState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, message];
}
