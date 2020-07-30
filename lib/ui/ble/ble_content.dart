import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/ui/ble/ble_bloc.dart';

//TODO HANDLE SCANNING STATE
//TODO CREATE FUNCTION TO TURN ON AND OFF BLUETOOTH NATIVELY
class BleContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BleContentState();
}

class _BleContentState extends State<BleContent> {
  BleBloc _bleBloc;

  @override
  void initState() {
    _bleBloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  void dispose() {
    _bleBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BleBloc, BleState>(
      listener: (context, state) {
        if (state is BleStatusMissingState) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              key: ValueKey('ble_missing_snackbar'),
              content: Text(
                'Bluetooth is not available on your device. \nReturning to previous screen...',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop();
          });
        }

        if (state is BleStatusOffState) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              key: ValueKey('ble_status_off'),
              content: Text(
                Platform.isAndroid
                    ? 'Bluetooth is off. Please turn on to continue scanning or click here'
                    : 'Bluetooth is off. Please turn on to continue scanning.',
                style: TextStyle(color: Colors.red),
              ),
              action: Platform.isAndroid
                  ? SnackBarAction(
                      textColor: Colors.green,
                      label: 'Turn On',
                      onPressed: () => _bleBloc.add(BleTurningOnEvent()),
                    )
                  : null,
              duration: Duration(days: 1),
            ),
          );
        }

        if (state is BleErrorState) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              key: ValueKey('ble_status_error'),
              content: Text(
                state.error,
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop();
          });
        }
      },
      child: _buildStateView(),
    );
  }

  Widget _buildStateView() {
    return BlocBuilder<BleBloc, BleState>(
      builder: (context, state) {
        return Container();
      },
    );
  }
}
