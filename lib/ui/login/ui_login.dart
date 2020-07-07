import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/extension/constants.dart';
import 'package:flutterapp/ui/extension/widget_extension.dart';
import 'package:flutterapp/ui/login/login/login_bloc.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc.init();
  }

  @override
  void dispose() {
    _loginBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _loginBloc,
      child: Container(
        decoration: const BoxDecoration(
          image: const DecorationImage(
            image: const AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.center,
          widthFactor: 0.9,
          heightFactor: 0.6,
          child: SingleChildScrollView(
            child: Card(
              shadowColor: Colors.white60,
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: Colors.white,
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      LOGIN_BODY,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: const Color(0xFF52575C),
                          fontSize: 28,
                          fontFamily: 'RobotoBold'),
                    ),
                  ),
                  const Divider(
                    color: Colors.black54,
                    thickness: 1.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _buildEmailField(_loginBloc),
                        _buildPasswordField(_loginBloc),
                        buildSpacer(22.0),
                        _buildLoginButton(_loginBloc),
                        buildSpacer(30.0),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// WIDGETS BUILDER ///
@widget
Widget _buildEmailField(LoginBloc bloc) {
  return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
    return TextField(
      controller: bloc.emailController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      maxLines: 1,
      cursorColor: const Color(0xFF31B057),
      style: TextStyle(color: const Color(0xFF52575C)),
      decoration: InputDecoration(
        hintText: LOGIN_EMAIL_HINT,
        labelText: LOGIN_EMAIL_LABEL,
        labelStyle: TextStyle(
          color: const Color(0xFF31B057),
        ),
        enabledBorder: buildBorder(),
        focusedBorder: buildBorder(),
        errorText:
            (state is! LoginFailure) ? null : (state as LoginFailure).error[0],
      ),
    );
  });
}

@widget
Widget _buildPasswordField(LoginBloc bloc) {
  return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
    return TextField(
      controller: bloc.passwordController,
      textInputAction: TextInputAction.done,
      //obscureText: visibility.data != null ? visibility.data : true,
      keyboardType: TextInputType.text,
      maxLines: 1,
      cursorColor: const Color(0xFF31B057),
      style: TextStyle(color: const Color(0xFF52575C)),
      decoration: InputDecoration(
        focusColor: const Color(0xFF31B057),
        hintText: LOGIN_PASSWORD_HINT,
        labelText: LOGIN_PASSWORD_LABEL,
        labelStyle: TextStyle(
          color: const Color(0xFF31B057),
        ),
        enabledBorder: buildBorder(),
        focusedBorder: buildBorder(),
        errorText:
        (state is! LoginFailure) ? null : (state as LoginFailure).error[1],
        /*suffixIcon: IconButton(
        onPressed: () => bloc.toggleVisibility,
            icon: Icon(
              visibility.data != null ? Icons.visibility_off : Icons.visibility,
            ),
        color: const Color(0xFF31B057),
        iconSize: 18.0,
      ),*/
      ),
    );
  });
}

@widget
Widget _buildLoginButton(LoginBloc bloc) {
  return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
    return (state is LoginLoading)
        ? CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF31B057)),
    )
        : SizedBox(
      width: double.infinity,
      child: RaisedButton(
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              width: 2.0,
              color: const Color(0xFF31B057),
            ),
          ),
          elevation: 8,
          color: Colors.white,
          child: Text(
            LOGIN_BUTTON,
            style: TextStyle(
              color: const Color(0xFF52575C),
              fontSize: 16,
              fontFamily: 'RobotoReg',
            ),
          ),
          onPressed: () =>
          {
            FocusScope.of(context).unfocus(),
            bloc.onFormSubmitted(),
          }),
    );
  });
}

@widget
UnderlineInputBorder buildBorder() {
  return UnderlineInputBorder(
    borderSide: new BorderSide(
      color: const Color(0xFF31B057),
    ),
  );
}
