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
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: buildAppBar(title: LOGIN_TITLE),
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
