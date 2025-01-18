import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop_app/features/auth/domain/domain.dart';
import 'package:teslo_shop_app/features/auth/infrastructure/infrastructure.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();

  return AuthNotifier(authRepository: authRepository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;

  AuthNotifier({required this.authRepository}) : super(AuthState());

  void loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error inesperado');
    }
  }

  void registerUser(String email, String password, String fullName) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final user = await authRepository.register(email, password, fullName);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      print(e.toString());
      logout('Error inesperado');
    }
  }

  void checkAuthStatus() async {}

  _setLoggedUser(User user) {
    // TODO: Guardar el token fisicamente
    state = state.copyWith(
      authStatus: AuthStatus.authenticated,
      user: user,
    );
  }

  Future<void> logout([String? errorMessage]) async {
    // TODO: Limpiar token
    state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        errorMessage: errorMessage);
  }
}

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState(
      {this.authStatus = AuthStatus.checking,
      this.user,
      this.errorMessage = ''});

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
