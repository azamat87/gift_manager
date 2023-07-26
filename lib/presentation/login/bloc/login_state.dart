part of 'login_bloc.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool emailValid;
  final bool passwordValid;
  final bool authenticated;
  final EmailError emailError;
  final PasswordError passwordError;
  final RequestError requestError;

  const LoginState({
    required this.email,
    required this.password,
    required this.emailValid,
    required this.passwordValid,
    required this.authenticated,
    required this.emailError,
    required this.passwordError,
    required this.requestError,
  });

  factory LoginState.initial() => const LoginState(
      email: '',
      password: '',
      emailValid: false,
      passwordValid: false,
      authenticated: false,
      emailError: EmailError.noError,
      passwordError: PasswordError.noError,
      requestError: RequestError.noError);

  bool get allFieldsValid => emailValid && passwordValid;

  LoginState copyWith(
      {final String? email,
      final String? password,
      final bool? emailValid,
      final bool? passwordValid,
      final bool? authenticated,
      final EmailError? emailError,
      final PasswordError? passwordError,
      final RequestError? requestError}) {
    return LoginState(
        email: email ?? this.email,
        password: password ?? this.password,
        emailValid: emailValid ?? this.emailValid,
        passwordValid: passwordValid ?? this.passwordValid,
        authenticated: authenticated ?? this.authenticated,
        emailError: emailError ?? this.emailError,
        passwordError: passwordError ?? this.passwordError,
        requestError: requestError ?? this.requestError);
  }

  @override
  List<Object?> get props => [
        email,
        password,
        emailValid,
        passwordValid,
        authenticated,
        emailError,
        passwordError,
        requestError
      ];
}
