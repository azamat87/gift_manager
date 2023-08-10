import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gift_manager/extensions/build_context.dart';
import 'package:gift_manager/extensions/theme_extensions.dart';
import 'package:gift_manager/presentation/home/view/home_page.dart';
import 'package:gift_manager/resources/app_colors.dart';

import '../bloc/registration_bloc.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegistrationBloc(),
      child: Scaffold(
        body: _RegistrationPageWidget(),
      ),
    );
  }
}

class _RegistrationPageWidget extends StatefulWidget {
  const _RegistrationPageWidget({Key? key}) : super(key: key);

  @override
  State<_RegistrationPageWidget> createState() =>
      _RegistrationPageWidgetState();
}

class _RegistrationPageWidgetState extends State<_RegistrationPageWidget> {
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _passwordConfirmationFocusNode;
  late final FocusNode _nameFocusNode;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _passwordConfirmationFocusNode = FocusNode();
    _nameFocusNode = FocusNode();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _emailFocusNode.addListener(() {
        if (!_emailFocusNode.hasFocus) {
          context
              .read<RegistrationBloc>()
              .add(const RegistrationEmailFocusLost());
        }
      });
      _passwordFocusNode.addListener(() {
        if (!_passwordFocusNode.hasFocus) {
          context
              .read<RegistrationBloc>()
              .add(const RegistrationPasswordFocusLost());
        }
      });
      _passwordConfirmationFocusNode.addListener(() {
        if (!_passwordConfirmationFocusNode.hasFocus) {
          context
              .read<RegistrationBloc>()
              .add(const RegistrationPasswordConfirmationFocusLost());
        }
      });
      _nameFocusNode.addListener(() {
        if (!_nameFocusNode.hasFocus) {
          context
              .read<RegistrationBloc>()
              .add(const RegistrationNameFocusLost());
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordConfirmationFocusNode.dispose();
    _nameFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state is RegistrationCompleted) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false);
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Создать аккаунт",
                        style: context.theme.h2,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    _EmailTextField(
                        emailFocusNode: _emailFocusNode,
                        passwordFocusNode: _passwordFocusNode),
                    const SizedBox(
                      height: 16,
                    ),
                    _PasswordTextField(
                        passwordFocusNode: _passwordFocusNode,
                        passwordConfirmationFocusNode:
                            _passwordConfirmationFocusNode),
                    _PasswordConfirmationField(
                        passwordConfirmationFocusNode:
                            _passwordConfirmationFocusNode,
                        nameFocusNode: _nameFocusNode),
                    _NameTextField(nameFocusNode: _nameFocusNode),
                    _AvatarWidget(),
                  ],
                ),
              ),
              _RegisterButton()
            ],
          ),
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        buildWhen: (_, current) => current is RegistrationFieldsInfo,
        builder: (context, state) {
          final fieldsInfo = state as RegistrationFieldsInfo;
          final error = fieldsInfo.emailError;
          return TextField(
            focusNode: emailFocusNode,
            onSubmitted: (_) => passwordFocusNode.requestFocus(),
            onChanged: (text) => context
                .read<RegistrationBloc>()
                .add(RegistrationEmailChanged(text)),
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                labelText: "Почта", errorText: error?.toString()),
          );
        },
      ),
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  final FocusNode passwordFocusNode;
  final FocusNode passwordConfirmationFocusNode;

  const _PasswordTextField(
      {super.key,
      required this.passwordFocusNode,
      required this.passwordConfirmationFocusNode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        buildWhen: (_, current) => current is RegistrationFieldsInfo,
        builder: (context, state) {
          final fieldsInfo = state as RegistrationFieldsInfo;
          final error = fieldsInfo.passwordError;
          return TextField(
            focusNode: passwordFocusNode,
            onSubmitted: (_) => passwordConfirmationFocusNode.requestFocus(),
            onChanged: (text) => context
                .read<RegistrationBloc>()
                .add(RegistrationPasswordChanged(text)),
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
                labelText: "Пароль", errorText: error?.toString()),
          );
        },
      ),
    );
  }
}

class _PasswordConfirmationField extends StatelessWidget {
  final FocusNode passwordConfirmationFocusNode;
  final FocusNode nameFocusNode;

  const _PasswordConfirmationField(
      {super.key,
      required this.passwordConfirmationFocusNode,
      required this.nameFocusNode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        buildWhen: (_, current) => current is RegistrationFieldsInfo,
        builder: (context, state) {
          final fieldsInfo = state as RegistrationFieldsInfo;
          final error = fieldsInfo.passwordConfirmationError;
          return TextField(
            focusNode: passwordConfirmationFocusNode,
            onSubmitted: (_) => nameFocusNode.requestFocus(),
            onChanged: (text) => context
                .read<RegistrationBloc>()
                .add(RegistrationPasswordConfirmationChanged(text)),
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
                labelText: "Пароль второй раз", errorText: error?.toString()),
          );
        },
      ),
    );
  }
}

class _NameTextField extends StatelessWidget {
  final FocusNode nameFocusNode;

  const _NameTextField({super.key, required this.nameFocusNode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        buildWhen: (_, current) => current is RegistrationFieldsInfo,
        builder: (context, state) {
          final fieldsInfo = state as RegistrationFieldsInfo;
          final error = fieldsInfo.nameError;
          return TextField(
            focusNode: nameFocusNode,
            onSubmitted: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            onChanged: (text) => context
                .read<RegistrationBloc>()
                .add(RegistrationNameChanged(text)),
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: "Имя и фамилия", errorText: error?.toString()),
          );
        },
      ),
    );
  }
}

class _AvatarWidget extends StatelessWidget {
  const _AvatarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.only(left: 8, top: 6, bottom: 6, right: 4),
      decoration: BoxDecoration(
          color: context.dynamicPaintColor(
              lightThemeColor: AppColors.lightLightBlue100,
              darkThemeColor: AppColors.darkWhite20),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          BlocBuilder<RegistrationBloc, RegistrationState>(
            buildWhen: (_, current) => current is RegistrationFieldsInfo,
            builder: (context, state) {
              final fieldsInfo = state as RegistrationFieldsInfo;
              return SvgPicture.network(
                fieldsInfo.avatarLink,
                height: 48,
                width: 48,
              );
            },
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            "Ваш аватар",
            style: context.theme.h3,
          ),
          const SizedBox(
            width: 8,
          ),
          const Spacer(),
          TextButton(
              onPressed: () {
                context
                    .read<RegistrationBloc>()
                    .add(const RegistrationChangeAvatar());
              },
              child: Text("Изменить"))
        ],
      ),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: BlocSelector<RegistrationBloc, RegistrationState, bool>(
          selector: (state) => state is RegistrationInProgress,
          builder: (context, inProgress) {
            return ElevatedButton(
              onPressed: inProgress
                  ? null
                  : () => context
                      .read<RegistrationBloc>()
                      .add(const RegistrationCreateAccount()),
              child: Text("Создать"),
            );
          },
        ),
      ),
    );
  }
}
