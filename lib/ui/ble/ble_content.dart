import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutterapp/extension/extension.dart';
import 'package:flutterapp/ui/ble/ble_bloc.dart';
import 'package:flutterapp/ui/extension/widget_extension.dart';

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
        if (state is BleStatusOffState) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              key: ValueKey('ble_status_off'),
              content: Text(
                Platform.isAndroid
                    ? 'Bluetooth is off. Please turn on to continue scanning or click here...'
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
        if (state is BleScanningCompletedState) {
          final _data = state.list;
          return _data.isEmpty ? _buildError(false) : _buildListView(_data);
        }
        return _buildLoadingProgress();
      },
    );
  }

  Widget _buildLoadingProgress() {
    return Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: CircularProgressIndicator(
          strokeWidth: 8.0,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF52575C)),
        ),
      ),
    );
  }

  Widget _buildListView(List<BluetoothDevice> list) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${list[index].name}'),
          );
        });
  }

  Widget _buildError(bool isError) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildImageError(isError),
          buildSpacer(22),
          _buildTitleError(),
          buildSpacer(18),
          _buildSubtitleError(isError),
          buildSpacer(22),
          _buildButtonError(),
        ],
      ),
    );
  }

  Widget _buildImageError(bool isError) {
    return Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(isError
                ? 'assets/images/error.png'
                : 'assets/images/empty_json.png'),
            fit: BoxFit.fill,
          ),
          shape: BoxShape.rectangle,
        ));
  }

  Widget _buildTitleError() {
    return Text(
      HOME_ERROR_TITLE,
      style: TextStyle(
          color: const Color(0xFF4A4A4A),
          fontSize: 20,
          fontFamily: 'RobotoBold'),
    );
  }

  Widget _buildSubtitleError(bool isError) {
    return Text(
      isError ? HOME_ERROR_SUBTITLE : HOME_EMPTY_SUBTITLE,
      style: TextStyle(
          color: const Color(0xFF4A4A4A),
          fontSize: 16,
          fontFamily: 'RobotoReg'),
    );
  }

  Widget _buildButtonError() {
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
            HOME_ERROR_BUTTON,
            style: TextStyle(
              color: const Color(0xFF31B057),
              fontSize: 16,
              fontFamily: 'RobotoBold',
            ),
          ),
          onPressed: () => {
                FocusScope.of(context).unfocus(),
                _bleBloc.add(BleStartScanningEvent()),
              }),
    );
  }
}
