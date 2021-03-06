import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/data/entities/model_entity.dart';
import 'package:flutterapp/extension/constants.dart';
import 'package:flutterapp/extension/dialogs/dialog_listener.dart';
import 'package:flutterapp/extension/dialogs/dialog_type.dart';
import 'package:flutterapp/extension/string.dart';
import 'package:flutterapp/ui/authentication/authentication_bloc.dart';
import 'package:flutterapp/ui/autowifi/autowifi_page.dart';
import 'package:flutterapp/ui/ble/ble_page.dart';
import 'package:flutterapp/ui/camera/camera_page.dart';
import 'package:flutterapp/ui/extension/app_theme.dart';
import 'package:flutterapp/ui/extension/widget_extension.dart';
import 'package:flutterapp/ui/tabs/tab_page.dart';
import 'package:flutterapp/ui/webview.dart';

import 'home_bloc.dart';

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, [this.icon = Icons.add]);
}

final _drawerItemList = [
  DrawerItem('Camera', Icons.camera_alt),
  DrawerItem('Bluetooth LE (WIP)', Icons.bluetooth),
  DrawerItem('AutoWifi (WIP)', Icons.wifi),
  DrawerItem('Tabs/ViewPager (WIP)', Icons.wifi),
];

class HomeContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> implements DialogListener {
  HomeBloc _homeBloc;
  AuthenticationBloc _authBloc;
  int _selectedDrawerIndex = 0;

  @override
  void initState() {
    _homeBloc = BlocProvider.of(context);
    _authBloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  void dispose() {
    _homeBloc.close();
    _authBloc.close();
    super.dispose();
  }

  @override
  void onNegativeButtonClicked(DialogType type, dynamic t) {
    Fimber.d('onNegativeButtonClicked: $type, $t');
  }

  @override
  void onPositiveButtonClicked(DialogType type, dynamic t) {
    if (type == DialogType.DIALOG_CONFIRM_DELETE) {
      _homeBloc.deleteItemList(t as ModelEntity);
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  void _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => _navigateToIndex(index)));
  }

  Widget _navigateToIndex(int index) {
    switch (index) {
      case 0:
        return CameraPage();
      case 1:
        return BlePage();
      case 2:
        return AutoWifiPage();
      case 3:
        return TabPage();
      default:
        return Container(
          child: Text('jkl'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    var drawerItems = <Widget>[];
    for (var i = 0; i < _drawerItemList.length; i++) {
      var item = _drawerItemList[i];
      drawerItems.add(ListTile(
        trailing: Icon(item.icon),
        title: Text(item.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return WillPopScope(
      onWillPop: () =>
          context.buildAlertDialog(DialogType.DIALOG_EXIT_APP, this),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    _buildDrawerHeader(),
                    Column(
                      children: drawerItems,
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: AppTheme.grey.withOpacity(0.6),
              ),
              ListTile(
                title: Text(
                  'Sign Out',
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppTheme.darkText,
                  ),
                  textAlign: TextAlign.left,
                ),
                trailing: Icon(
                  Icons.power_settings_new,
                  color: Colors.grey,
                ),
                onTap: () => _homeBloc.handleOptionsMenu(0),
              ),
            ],
          ),
        ),
        appBar: buildAppBar(HOME_TITLE, _buildPopUpMenu()),
        body: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {},
          child: Container(
            child: RefreshIndicator(
              onRefresh: () => _homeBloc.fetchData(),
              child: _buildStateView(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStateView() {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state is HomeLoadingState) {
        return _buildLoadingProgress();
      }

      if (state is HomeFailureState) {
        return _buildError(true);
      }

      if (state is HomeSuccessState) {
        return _buildListView();
      }

      return Container();
    });
  }

  Widget _buildPopUpMenu() {
    return PopupMenuButton<int>(
      padding: EdgeInsets.zero,
      onSelected: (value) => _homeBloc.handleOptionsMenu(value),
      itemBuilder: (context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 1,
          textStyle: TextStyle(
              color: const Color(0xFF52575C), fontFamily: 'RobotoBold'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(
                Icons.stars,
                color: const Color(0xFF52575C),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                child: Text(HOME_OPTION_SORT_STAR),
              ),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          textStyle: TextStyle(
              color: const Color(0xFF52575C), fontFamily: 'RobotoBold'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(
                Icons.build,
                color: const Color(0xFF52575C),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                child: Text(HOME_OPTION_SORT_FORK),
              ),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 3,
          textStyle: TextStyle(
              color: const Color(0xFF52575C), fontFamily: 'RobotoBold'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(
                Icons.shuffle,
                color: const Color(0xFF52575C),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                child: Text(HOME_OPTION_SORT_RANDOM),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDrawerHeader() {
    return UserAccountsDrawerHeader(
      currentAccountPicture: _buildUserAvatar(),
      accountName: _buildUserName(),
      accountEmail: _buildUserEmail(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover)),
    );
  }

  Widget _buildUserEmail() {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return _buildUserText(state is AuthenticationSuccessState
            ? 'Email: ${state.emailAddress}'
            : 'Email: Unknown');
      },
    );
  }

  Widget _buildUserName() {
    return _buildUserText('Username: root');
  }

  Widget _buildUserText(String text) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: const Color(0xFF52575C),
          fontSize: 16,
          fontFamily: 'RobotoBold'),
    );
  }

  Widget _buildUserAvatar() {
    return CircleAvatar(
      backgroundColor: Colors.black,
      child: ClipRRect(
        child: Image.asset('assets/images/user.png'),
      ),
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

  Widget _buildListView() {
    final _data = (_homeBloc.state as HomeSuccessState).entities;
    return _data.isEmpty
        ? _buildError(false)
        : Scaffold(
            backgroundColor: Colors.white,
            body: ReorderableListView(
              onReorder: (a, b) => _homeBloc.onReorder(a, b),
              children: _getItemList(_data),
            ),
          );
  }

  List<Widget> _getItemList(List<ModelEntity> list) {
    return list
        .asMap()
        .map((index, value) =>
            MapEntry(index, _buildDismissibleList(index, value)))
        .values
        .toList();
  }

  Widget _buildDismissibleList(int index, ModelEntity e) {
    return Dismissible(
      key: ValueKey(e),
      confirmDismiss: (direction) =>
          context.buildAlertDialog(DialogType.DIALOG_CONFIRM_DELETE, this, e),
      direction: DismissDirection.endToStart,
      background: _buildDismissBackground(),
      child: _buildExpansionTile(e),
    );
  }

  Widget _buildExpansionTile(ModelEntity e) {
    return ExpansionTile(
      key: ValueKey(e),
      trailing: Visibility(visible: false, child: Icon(Icons.more_vert)),
      leading: _buildAvatarViewHolder(e),
      title: _buildAuthorViewHolder(e),
      subtitle: _buildNameViewHolder(e),
      children: <Widget>[
        _buildBody(e),
      ],
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      padding: EdgeInsets.all(10.0),
      color: Colors.red,
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete_forever,
              color: Colors.white,
            ),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarViewHolder(ModelEntity model) {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WebViewContent(entity: model))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: FadeInImage.assetNetwork(
          fit: BoxFit.cover,
          width: 40,
          height: 40,
          placeholder: 'assets/images/image_error.png',
          image: model.avatar,
        ),
      ),
    );
  }

  Widget _buildAuthorViewHolder(ModelEntity model) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        model.author,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: const Color(0xFF52575C),
            fontSize: 12,
            fontFamily: 'RobotoReg'),
      ),
    );
  }

  Widget _buildNameViewHolder(ModelEntity model) {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 5.0),
      child: Text(
        model.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: const Color(0xFF52575C),
            fontSize: 16,
            fontFamily: 'RobotoReg'),
      ),
    );
  }

  Widget _buildBody(ModelEntity model) {
    return Column(
      children: <Widget>[
        _buildDescriptionViewHolder(model),
        Row(
          children: <Widget>[
            _buildLanguageViewHolder(model),
            _buildStarsViewHolder(model),
            _buildForksViewHolder(model),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptionViewHolder(ModelEntity model) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(60.0, 5.0, 20.0, 5.0),
      child: Text(
        model.description,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: const Color(0xFF52575C),
          fontSize: 12,
          fontFamily: 'PingFang',
        ),
      ),
    );
  }

  Widget _buildLanguageViewHolder(ModelEntity model) {
    return Visibility(
      visible: model.language != null,
      child: Container(
        alignment: Alignment.topLeft,
        margin: const EdgeInsets.fromLTRB(60.0, 0.0, 5.0, 5.0),
        child: Row(
          children: <Widget>[
            Container(
                margin: EdgeInsets.all(5.0),
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color:
                  model.languageColor?.parseColorFromHex() ?? Colors.black,
                  shape: BoxShape.circle,
                )),
            Text(
              model.language ?? 'Unknown',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: const Color(0xFF52575C),
                fontSize: 12,
                fontFamily: 'RobotoReg',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarsViewHolder(ModelEntity model) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.fromLTRB(
          model.language != null ? 5.0 : 60.0, 0.0, 5.0, 5.0),
      child: Row(
        children: <Widget>[
          Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/star.png'),
                  fit: BoxFit.fill,
                ),
                shape: BoxShape.rectangle,
              )),
          Text(
            model.stars.toString(),
            textAlign: TextAlign.start,
            style: TextStyle(
              color: const Color(0xFF52575C),
              fontSize: 12,
              fontFamily: 'RobotoReg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForksViewHolder(ModelEntity model) {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
      child: Row(
        children: <Widget>[
          Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/fork.png'),
                  fit: BoxFit.fill,
                ),
                shape: BoxShape.rectangle,
              )),
          Text(
            model.forks.toString(),
            textAlign: TextAlign.start,
            style: TextStyle(
              color: const Color(0xFF52575C),
              fontSize: 12,
              fontFamily: 'RobotoReg',
            ),
          ),
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
          onPressed: () =>
          {
            FocusScope.of(context).unfocus(),
            _homeBloc.fetchData(),
          }),
    );
  }
}
