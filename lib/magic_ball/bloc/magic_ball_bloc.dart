import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:magic_8_ball/magic_ball/data/magic_ball_repository.dart';

part 'magic_ball_event.dart';
part 'magic_ball_state.dart';

class MagicBallBloc extends Bloc<MagicBallEvent, MagicBallState> {
  final MagicBallRepository _repository;
  
  MagicBallBloc({
    MagicBallRepository? repository,
  }) : _repository = repository ?? const MagicBallRepository(),
       super(const MagicBallState()) {
    on<GetPrediction>(_onGetPrediction);
  }

  Future<void> _onGetPrediction(
    GetPrediction event,
    Emitter<MagicBallState> emit,
  ) async {
    emit(state.copyWith(status: MagicBallStatus.loading));
    try {
      // Add synthetic delay to simulate "thinking" process
      // This makes the Magic 8-Ball feel more mystical and realistic
      await Future.delayed(const Duration(milliseconds: 2500));
      
      final message = await _repository.getPrediction();
      emit(
        state.copyWith(
          status: MagicBallStatus.loaded,
          message: message,
        ),
      );
    } catch (e) {
      // Even for errors, add a small delay to feel natural
      await Future.delayed(const Duration(milliseconds: 1500));
      emit(
        state.copyWith(
          status: MagicBallStatus.error,
          message: 'Failed to get prediction. Try again!',
        ),
      );
    }
  }
}
