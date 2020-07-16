import 'package:flutter/material.dart';
import 'package:flutterapp/extension/dialogs/dialog_listener.dart';
import 'package:flutterapp/extension/dialogs/dialog_type.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

@widget
Widget buildAppBar({String title}) {
  return AppBar(
    title: Text(
      title,
      style: const TextStyle(color: Color(0xFF25282B)),
    ),
    centerTitle: true,
    backgroundColor: Colors.white,
  );
}

@widget
Widget buildSpacer(double height) {
  return SizedBox(
    height: height,
  );
}

UnderlineInputBorder buildBorder() {
  return UnderlineInputBorder(
    borderSide: new BorderSide(
      color: const Color(0xFF31B057),
    ),
  );
}

extension Navigation on BuildContext {
  void navigate(StatefulWidget route) {
    Navigator.pushReplacement(
        this, MaterialPageRoute(builder: (context) => route));
  }

  Future<bool> buildAlertDialog(
    DialogType type,
    dynamic t,
    DialogListener listener,
  ) async {
    return await showDialog(
        context: this,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
              title: Text(type.title),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[Text(type.message)],
                ),
              ),
              actions: <Widget>[
                type.nBtn != null
                    ? FlatButton(
                        child: Text(type.nBtn),
                        onPressed: () => {
                              Navigator.pop(this),
                              listener.onNegativeButtonClicked(type, t),
                            })
                    : Container(),
                FlatButton(
                    child: Text(type.pBtn),
                    onPressed: () => {
                          Navigator.pop(this),
                          listener.onPositiveButtonClicked(type, t),
                        })
              ],
            ));
  }
}
