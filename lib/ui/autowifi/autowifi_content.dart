import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/data/wifi/scan_result.dart';

import 'autowifi_bloc.dart';

class AutoWifiContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AutoWifiState();
}

class _AutoWifiState extends State<AutoWifiContent> {
  AutoWifiBloc _wifiBloc;

  @override
  void initState() {
    _wifiBloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  void dispose() {
    _wifiBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AutoWifiBloc, AutoWifiState>(
      listener: (context, state) {
        if (state is AutoWifiErrorState) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              key: ValueKey('autowifi_snackbar'),
              content: Text(state.error),
              duration: Duration(days: 1),
            ),
          );
        }
      },
      child: _buildStateView(),
    );
  }

  Widget _buildStateView() {
    return BlocBuilder<AutoWifiBloc, AutoWifiState>(
      builder: (context, state) {
        if (state is AutoWifiScanCompleteState) {
          final _data = state.list;
          return _data.isEmpty ? Container() : _buildListView(_data);
        }

        if (state is AutoWifiSuccessState) {
          return Container(
            child: Text('all OK!'),
          );
        }

        return _buildLoadingProgress();
      },
    );
  }

  Widget _buildListView(List<ScanResult> list) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text('SSID: ${list[index].SSID ?? '(unknown ssid)'}'),
            title: Text(
                'Capabilities: ${list[index].capabilities.isNotEmpty ? list[index].capabilities : '(unknown capabilities)'}'),
            subtitle: Text(
                'Level/Frequency: ${list[index].level} /  ${list[index].frequency}'),
            dense: true,
            onTap: () => _showBottomDialog(list[index]),
          );
        });
  }

  void _showBottomDialog(ScanResult result) {
    var _controller = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          border: InputBorder.none,
                          hintText: 'abc123'),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _wifiBloc.add(AutoWifiAttemptConnectEvent(
                              scanResult: result, pwd: _controller.text));
                        },
                        child: Text(
                          'OK',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: const Color(0xFF1BC0C5),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
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
}
