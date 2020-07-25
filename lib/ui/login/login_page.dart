import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/extension/constants.dart';
import 'package:flutterapp/ui/authentication/authentication_bloc.dart';
import 'package:flutterapp/ui/extension/widget_extension.dart';
import 'package:flutterapp/ui/login/login_bloc.dart';
import 'package:flutterapp/ui/login/login_form.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('login_page'),
      decoration: buildBackground(),
      child: Scaffold(
        appBar: buildAppBar(LOGIN_TITLE),
        backgroundColor: Colors.transparent,
        body: BlocProvider(
          create: (context) {
            return LoginBloc(
                authBloc: BlocProvider.of<AuthenticationBloc>(context));
          },
          child: LoginForm(),
        ),
      ),
    );
  }
}
