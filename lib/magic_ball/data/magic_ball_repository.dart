import 'magic_ball_api.dart';

/// Repository for managing Magic Ball predictions
/// 
/// Provides a clean interface for the BLoC to get predictions
/// without knowing about the specific API implementation
class MagicBallRepository {
  final MagicBallApi _api;

  const MagicBallRepository({
    MagicBallApi? api,
  }) : _api = api ?? const MagicBallApi();

  /// Gets a prediction from the Magic 8-Ball
  /// 
  /// Returns the prediction text on success
  /// Throws an exception on error
  Future<String> getPrediction() async {
    return await _api.getPrediction();
  }
}

/// Default instance of MagicBallApi
const MagicBallApi _defaultApi = MagicBallApi();
