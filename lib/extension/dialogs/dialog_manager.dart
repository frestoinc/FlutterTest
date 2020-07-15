import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/di/inject.dart';

import 'file:///C:/Users/root/Documents/AndroidStudioProjects/Projects/flutter_app/lib/extension/dialogs/dialog.dart';

import 'dialog_type.dart';

class DialogManager extends StatefulWidget {
  final Widget child;
  final DialogType dialogType;

  DialogManager({Key key, this.child, this.dialogType}) : super(key: key);

  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  @override
  void initState() {
    super.initState();
    getIt<DialogService>()
        .registerDialogListener(_showDialog(widget.dialogType));
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  //todo
  Future<void> _showDialog(DialogType type) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
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
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  : Container(),
              FlatButton(
                child: Text(type.pBtn),
                onPressed: () => {},
              )
            ],
          );
        });
  }
}
