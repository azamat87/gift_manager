import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.initial()) {
    on<LoginLoginButtonClicked>(_loginButtonClicked);
  }

  FutureOr<void> _loginButtonClicked(LoginLoginButtonClicked event, Emitter<LoginState> emit) {
    emit(state.copyWith(authenticated: true));
  }

}
