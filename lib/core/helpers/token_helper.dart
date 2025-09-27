import 'package:jwt_decoder/jwt_decoder.dart';

class TokenHelper {
  /// تستخرج الـ User ID من توكين JWT
  static String? extractUserId(String token) {
    try {
      Map<String, dynamic> decoded = JwtDecoder.decode(token);
      return decoded['sub'] as String?;
    } catch (e) {
      return null;
    }
  }
}
