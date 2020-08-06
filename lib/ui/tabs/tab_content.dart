import 'package:flutter/material.dart';
import 'package:flutterapp/ui/extension/widget_extension.dart';
import 'package:flutterapp/ui/tabs/tab_bloc.dart';

class TabContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabContentState();
}

class _TabContentState extends State<TabContent>
    with SingleTickerProviderStateMixin {
  TabBloc _tabBloc;
  TabController tabController;

  @override
  void initState() {
    super.initState();
    _tabBloc = TabBloc();

    tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    //_tabBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: buildBackground(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('TAB TEST'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                child: Text('Page 1'),
              ),
              Tab(
                  child: Text(
                'Page 2',
              )),
            ],
            indicatorColor: Colors.blue,
            controller: tabController,
          ),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return TabBarView(
      controller: tabController,
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Container(
            child: _buildFirstPage(),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            child: _buildSecondPage(),
          ),
        ),
      ],
    );
  }

  Widget _buildFirstPage() {
    return StreamBuilder<Response<String>>(
        stream: _tabBloc.controllerStream,
        builder: (ctx, snapshot) {
          if (snapshot.data?.status == Status.LOADING) {
            return CircularProgressIndicator();
          }

          if (snapshot.data?.status == Status.SUCCESS) {
            return Text('Recieved: ${snapshot.data.data}');
          }

          if (snapshot.data?.status == Status.ERROR) {
            return Text('Error: ${snapshot.data.message}');
          }
          return Text('NO DATA RECEIVED!!!!');
        });
  }

  Widget _buildSecondPage() {
    return Column(
      children: <Widget>[
        TextField(
          controller: _tabBloc.textController,
          decoration: InputDecoration(
            hintText: 'Anything',
            labelText: 'Enter Text',
            labelStyle: TextStyle(
              color: const Color(0xFF31B057),
            ),
            enabledBorder: buildBorder(),
            focusedBorder: buildBorder(),
          ),
        ),
        RaisedButton(
          child: Text('Proceed'),
          onPressed: () => _tabBloc.onButtonPressed(),
        )
      ],
    );
  }
}
