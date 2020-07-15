import 'package:flutter/material.dart';
import 'package:flutterapp/extension/constants.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool _loaded = false;

  void _toggleState() {
    _loaded = !_loaded;
    if (_loaded)
      _controller.reverse();
    else
      _controller.forward();
  }

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this)
      ..addStatusListener((status) {
        setState(() {});
        if (status == AnimationStatus.completed) {
          _toggleState();
        } else if (status == AnimationStatus.dismissed) {
          Future.delayed(const Duration(milliseconds: 500), () async {
            _toggleState();
          });
        }
      });
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: const DecorationImage(
          image: const AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildSplashText(message: SPLASH_BODY),
            _buildAnimation(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimation() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: new Image.asset(
        _loaded ? "assets/images/door1.png" : "assets/images/door2.png",
        key: ValueKey<bool>(_loaded),
      ),
    );
  }

  Widget _buildSplashText({String message}) {
    return Center(
      child: Text(
        message,
        softWrap: true,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Color(0xFF52575C), fontSize: 40, fontFamily: 'RobotoBold'),
      ),
    );
  }
}
