import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for interacting with the Magic Ball API
class MagicBallApi {
  static const String _baseUrl = 'http://localhost:3030/api';
  
  const MagicBallApi();

  /// Fetches a prediction from the Magic 8-Ball API
  /// 
  /// Returns the prediction text on success
  /// Throws an exception on error
  Future<String> getPrediction() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data['reading'] as String;
      } else {
        throw Exception('Failed to get prediction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
