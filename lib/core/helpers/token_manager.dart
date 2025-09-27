import 'package:ecommerce/core/helpers/cache_keys.dart';
import 'package:ecommerce/core/helpers/cache_network.dart';

class TokenManager {
  static String? get token => CacheNetwork.getCacheData(key: CacheKeys.token);
  static String? get refreshToken =>
      CacheNetwork.getCacheData(key: CacheKeys.refreshToken);
  static String? get userName =>
      CacheNetwork.getCacheData(key: CacheKeys.userName);
  static String? get email => CacheNetwork.getCacheData(key: CacheKeys.email);
  static String? get userId => CacheNetwork.getCacheData(key: CacheKeys.userId);
  static String? get guestId => CacheNetwork.getCacheData(key: CacheKeys.guestId);


  static DateTime? get expiration {
    final expirationStr = CacheNetwork.getCacheData(key: CacheKeys.expiration);
    if (expirationStr == null) return null;
    return DateTime.tryParse(expirationStr);
  }

  static DateTime? get refreshTokenExpiration {
    final refreshExpStr = CacheNetwork.getCacheData(
      key: CacheKeys.refreshTokenExpiration,
    );
    if (refreshExpStr == null) return null;
    return DateTime.tryParse(refreshExpStr);
  }

  static bool isTokenExpired() {
    final exp = expiration;
    if (exp == null) return true;
    return exp.isBefore(DateTime.now());
  }

  static bool isRefreshTokenExpired() {
    final exp = refreshTokenExpiration;
    if (exp == null) return true;
    return exp.isBefore(DateTime.now());
  }

  static Future<void> saveLoginData({
    required String token,
    required String refreshToken,
    required String expiration,
    required String refreshTokenExpirationDateTime,
    required String userName,
    required String email,
    required String userId,
  }) async {
    await CacheNetwork.insertToCache(key: CacheKeys.token, value: token);
    await CacheNetwork.insertToCache(
      key: CacheKeys.refreshToken,
      value: refreshToken,
    );
    await CacheNetwork.insertToCache(
      key: CacheKeys.expiration,
      value: expiration,
    );
    await CacheNetwork.insertToCache(
      key: CacheKeys.refreshTokenExpiration,
      value: refreshTokenExpirationDateTime,
    );
    await CacheNetwork.insertToCache(key: CacheKeys.userName, value: userName);
    await CacheNetwork.insertToCache(key: CacheKeys.email, value: email);
    await CacheNetwork.insertToCache(key: CacheKeys.userId, value: userId);
  }

  static Future<void> clear() async {
    await CacheNetwork.clearData();
  }
}
