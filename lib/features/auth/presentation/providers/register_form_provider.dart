import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop_app/features/shared/shared.dart';

// !3 - StateNotifierProvider - Consume afuera
final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
        (ref) {
  final registerUserCallback = ref.watch(authProvider.notifier).registerUser;

  return RegisterFormNotifier(registerUserCallback: registerUserCallback);
});

// !2 - Como implementar el StateNotifier
class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Function(String, String, String) registerUserCallback;

  RegisterFormNotifier({
    required this.registerUserCallback,
  }) : super(RegisterFormState());

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);

    state = state.copywith(
        email: newEmail,
        isValid: Formz.validate(
            [newEmail, state.password, state.repeatPassword, state.fullName]));
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);

    state = state.copywith(
        password: newPassword,
        isValid: Formz.validate(
            [newPassword, state.email, state.fullName, state.repeatPassword]));
  }

  onFullNameChange(String value) {
    final newFullName = FullName.dirty(value);

    state = state.copywith(
        fullName: newFullName,
        isValid: Formz.validate(
            [newFullName, state.email, state.password, state.repeatPassword]));
  }

  onRepeatPasswordChange(String value) {
    final newRepeatPassword = Password.dirty(value);

    state = state.copywith(
        repeatPassword: newRepeatPassword,
        isValid: Formz.validate(
            [newRepeatPassword, state.email, state.password, state.fullName]));
  }

  onFormSubmitted() async {
    _touchEveryField();

    if (!state.isValid) return;

    await registerUserCallback(
      state.email.value,
      state.password.value,
      state.fullName.value,
    );
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final fullName = FullName.dirty(state.fullName.value);
    final repeatPassword = Password.dirty(state.repeatPassword.value);

    state = state.copywith(
      isFormPosted: true,
      email: email,
      password: password,
      fullName: fullName,
      repeatPassword: repeatPassword,
      isValid: Formz.validate([email, password, fullName, repeatPassword]),
    );
  }
}

class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final FullName fullName;
  final Password password;
  final Password repeatPassword;

  RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.fullName = const FullName.pure(),
    this.repeatPassword = const Password.pure(),
  });

  RegisterFormState copywith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
    FullName? fullName,
    Password? repeatPassword,
  }) {
    return RegisterFormState(
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      email: email ?? this.email,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      repeatPassword: repeatPassword ?? this.repeatPassword,
    );
  }

  @override
  String toString() => '''RegisterFormState(
    isPosting: $isPosting,
    isFormPosted: $isFormPosted,
    isValid: $isValid,
    email: $email,
    password: $password,
    fullName: $fullName,
    repeatPassword: $repeatPassword,
  )''';
}
