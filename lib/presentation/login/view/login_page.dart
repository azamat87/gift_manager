import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_manager/data/request_error.dart';
import 'package:gift_manager/presentation/home/view/home_page.dart';
import 'package:gift_manager/presentation/login/model/email_error.dart';
import 'package:gift_manager/presentation/login/model/models.dart';

import '../bloc/login_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        body: _LoginPageWidget(),
      ),
    );
  }
}

class _LoginPageWidget extends StatefulWidget {
  @override
  State<_LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<_LoginPageWidget> {
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.authenticated) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const HomePage()));
            }
          },
        ),
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.requestError != RequestError.noError) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Произошла ошибка', style: TextStyle(color: Colors.white),),
                backgroundColor: Colors.red,
              ));
              context.read<LoginBloc>().add(const LoginRequestErrorShowed());
            }
          },
        ),
      ],
      child: Column(
        children: [
          const SizedBox(height: 64),
          const Center(
            child: Text(
              "Вход",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
            ),
          ),
          const Spacer(flex: 88),
          _EmailTextField(
            emailFocusNode: _emailFocusNode,
            passwordFocusNode: _passwordFocusNode,
          ),
          const SizedBox(
            height: 8,
          ),
          _PasswordTextField(passwordFocusNode: _passwordFocusNode),
          const SizedBox(
            height: 40,
          ),
          _LoginButton(),
          const SizedBox(
            height: 24,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Еще нет аккаунта"),
              TextButton(onPressed: () {}, child: const Text("Создать")),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          TextButton(onPressed: () {}, child: const Text("Не помню пароль")),
          const Spacer(flex: 284),
        ],
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: SizedBox(
        width: double.infinity,
        child: BlocSelector<LoginBloc, LoginState, bool>(
          selector: (state) {
            return state.allFieldsValid;
          },
          builder: (context, isValid) {
            return ElevatedButton(
                onPressed: isValid
                    ? () => context
                        .read<LoginBloc>()
                        .add(const LoginLoginButtonClicked())
                    : null,
                child: const Text("Войти"));
          },
        ),
      ),
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  final FocusNode passwordFocusNode;

  const _PasswordTextField({super.key, required this.passwordFocusNode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: BlocSelector<LoginBloc, LoginState, EmailError>(
        selector: (state) => state.emailError,
        builder: (context, emailError) {
          return TextField(
            focusNode: passwordFocusNode,
            onChanged: (text) =>
                context.read<LoginBloc>().add(LoginPasswordChanged(text)),
            onSubmitted: (_) =>
                context.read<LoginBloc>().add(const LoginLoginButtonClicked()),
            decoration: InputDecoration(
                hintText: "Пароль",
                errorText: emailError == EmailError.noError
                    ? null
                    : emailError.toString()),
          );
        },
      ),
    );
  }
}

class _EmailTextField extends StatelessWidget {
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;

  const _EmailTextField(
      {super.key,
      required this.emailFocusNode,
      required this.passwordFocusNode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: BlocSelector<LoginBloc, LoginState, PasswordError>(
        selector: (state) => state.passwordError,
        builder: (context, passwordError) {
          return TextField(
            focusNode: emailFocusNode,
            onSubmitted: (_) => passwordFocusNode.requestFocus(),
            onChanged: (text) =>
                context.read<LoginBloc>().add(LoginEmailChanged(text)),
            decoration: InputDecoration(
                hintText: "Почта",
                errorText: passwordError == PasswordError.noError
                    ? null
                    : PasswordError.wrongPassword.toString()),
          );
        },
      ),
    );
  }
}
