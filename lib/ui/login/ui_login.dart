import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/extension/string.dart';
import 'package:flutterapp/extension/validation_error.dart';
import 'package:flutterapp/ui/extension/widget_extension.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

AnimationController controller;
bool loaded = false;

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: const DecorationImage(
          image: const AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.center,
        widthFactor: 0.9,
        heightFactor: 0.9,
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
                    "Login Form",
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
                      _buildEmailFiled(),
                      _buildPasswordFiled(),
                      buildSpacer(22.0),
                      _buildLoginButton(),
                      buildSpacer(30.0),
                      AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          switchInCurve: Curves.easeIn,
                          switchOutCurve: Curves.easeOut,
                          child: new Image.asset(
                            loaded
                                ? "assets/images/door1.png"
                                : "assets/images/door2.png",
                            key: ValueKey<bool>(loaded),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    controller.addStatusListener((status) {
      setState(() {});
      if (status == AnimationStatus.completed) {
        loaded = !loaded;
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        Future.delayed(const Duration(milliseconds: 1000), () async {
          loaded = !loaded;
          controller.forward();
        });
      }
    });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

@widget
Widget _buildEmailFiled() {
  return StreamBuilder<Set<ValidationErrorEnum>>(
    stream: null, //todo
    builder: (ctx, snapshot) {
      return TextField(
        keyboardType: TextInputType.emailAddress,
        maxLines: 1,
        cursorColor: const Color(0xFF31B057),
        style: TextStyle(color: const Color(0xFF52575C)),
        decoration: InputDecoration(
            hintText: "r00t@gmail.com",
            labelText: "Email Address",
            labelStyle: TextStyle(
              color: const Color(0xFF31B057),
            ),
            enabledBorder: buildBorder(),
            focusedBorder: buildBorder(),
            errorText: getMessage(snapshot.data)),
      );
    },
  );
}

@widget
Widget _buildPasswordFiled() {
  return StreamBuilder<Set<ValidationErrorEnum>>(
    stream: null, //todo
    builder: (ctx, snapshot) {
      return TextField(
        keyboardType: TextInputType.text,
        obscureText: true,
        maxLines: 1,
        cursorColor: const Color(0xFF31B057),
        style: TextStyle(color: const Color(0xFF52575C)),
        decoration: InputDecoration(
            focusColor: const Color(0xFF31B057),
            hintText: "1q2w3e",
            labelText: "Password",
            labelStyle: TextStyle(
              color: const Color(0xFF31B057),
            ),
            enabledBorder: buildBorder(),
            focusedBorder: buildBorder(),
            errorText: getMessage(snapshot.data)),
      );
    },
  );
}

@widget
Widget _buildLoginButton() {
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
        'Login'.toUpperCase(),
        style: TextStyle(
          color: const Color(0xFF52575C),
          fontSize: 16,
          fontFamily: 'RobotoReg',
        ),
      ),
      onPressed: () {} /*_loginBloc.submitLogin*/,
    ),
  );
}

@widget
UnderlineInputBorder buildBorder() {
  return UnderlineInputBorder(
    borderSide: new BorderSide(
      color: const Color(0xFF31B057),
    ),
  );
}
