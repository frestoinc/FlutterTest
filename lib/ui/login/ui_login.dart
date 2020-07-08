import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/extension/constants.dart';
import 'package:flutterapp/ui/extension/widget_extension.dart';
import 'package:flutterapp/ui/login/login/login_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc _loginBloc;

  bool obscure = true;

  void _toggle() {
    setState(() {
      obscure = !obscure;
    });
  }

  @override
  void initState() {
    _loginBloc = LoginBloc.init();
    super.initState();
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
                        _buildEmailField(),
                        _buildPasswordField(),
                        buildSpacer(22.0),
                        _buildLoginButton(),
                        buildSpacer(30.0),
//                        Text(widget)
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

  Widget _buildPasswordField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextField(
        controller: _loginBloc.passwordController,
        textInputAction: TextInputAction.done,
        obscureText: obscure,
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
          errorText: (state is LoginFailure) ? state.error[1] : null,
          suffixIcon: IconButton(
            onPressed: () => _toggle(),
            icon: Icon(
              obscure ? Icons.visibility_off : Icons.visibility,
            ),
            color: const Color(0xFF31B057),
            iconSize: 18.0,
          ),
        ),
      );
    });
  }

  Widget _buildEmailField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextField(
        controller: _loginBloc.emailController,
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
          errorText: (state is LoginFailure) ? state.error[0] : null,
        ),
      );
    });
  }

  Widget _buildLoginButton() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      if (state is LoginLoading) {
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF31B057)),
        );
      } else if (state is LoginSuccess) {
        print("all ok");
        return Container();
      } else {
        return SizedBox(
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
              onPressed: () => {
                    FocusScope.of(context).unfocus(),
                    _loginBloc.onFormSubmitted(),
                  }),
        );
      }
    });
  }

  UnderlineInputBorder buildBorder() {
    return UnderlineInputBorder(
      borderSide: new BorderSide(
        color: const Color(0xFF31B057),
      ),
    );
  }
}
