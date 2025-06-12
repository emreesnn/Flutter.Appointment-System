import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

final dioProvider = Provider(
  (ref) => Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000/api')),
);

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<void>>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return AuthNotifier(dio);
});

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final Dio _dio;

  AuthNotifier(this._dio) : super(const AsyncData(null));

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    try {
      await _dio.post(
        '/register',
        data: {"username": username, "email": email, "password": password},
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();
    try {
      final response = await _dio.post(
        '/login',
        data: {"email": email, "password": password},
      );

      final jwt = response.data['jwt'];
      final user = response.data['user'];

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void logout() {
    state = const AsyncData(null);
    print("Kullanıcı çıkış yaptı");
  }
}
