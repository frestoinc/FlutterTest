import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/data/entities/model_entity.dart';
import 'package:flutterapp/extension/constants.dart';
import 'package:flutterapp/extension/dialogs/dialog_listener.dart';
import 'package:flutterapp/extension/dialogs/dialog_type.dart';
import 'package:flutterapp/extension/string.dart';
import 'package:flutterapp/ui/authentication/authentication.dart';
import 'package:flutterapp/ui/extension/widget_extension.dart';

import 'home_bloc.dart';

class HomeContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> implements DialogListener {
  HomeBloc _homeBloc;
  AuthenticationBloc _authBloc;

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[_buildDrawerHeader(), ListTile()],
        ),
      ),
      appBar: AppBar(
        title: Text(
          HOME_TITLE,
          style: const TextStyle(color: const Color(0xFF25282B)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Color(0xFF25282B),
        ),
        actions: [
          _buildPopUpMenu(),
        ],
      ),
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {},
        child: Container(
          child: RefreshIndicator(
            onRefresh: () => _homeBloc.fetchData(),
            child: _buildStateView(),
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
        const PopupMenuDivider(),
        PopupMenuItem<int>(
          value: 0,
          textStyle: TextStyle(
              color: const Color(0xFF52575C), fontFamily: 'RobotoBold'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(
                Icons.exit_to_app,
                color: const Color(0xFF52575C),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 2, 0, 2),
                child: Text(LOG_OUT),
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
            ? "Email: ${state.emailAddress}"
            : "Email: Unknown");
      },
    );
  }

  Widget _buildUserName() {
    return _buildUserText("Username: root");
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
        child: Image.asset("assets/images/user.png"),
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
          context.buildAlertDialog(DialogType.DIALOG_CONFIRM_DELETE, e, this),
      onDismissed: (_) => {print("onDismissed")},
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
              "Delete",
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: FadeInImage.assetNetwork(
        fit: BoxFit.cover,
        width: 40,
        height: 40,
        placeholder: "assets/images/image_error.png",
        image: model.avatar,
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
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.fromLTRB(60.0, 0.0, 5.0, 5.0),
      child: Row(
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(5.0),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: model.languageColor.parseColorFromHex(),
                shape: BoxShape.circle,
              )),
          Text(
            model.language == null ? "Unknown" : model.language,
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

  Widget _buildStarsViewHolder(ModelEntity model) {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
      child: Row(
        children: <Widget>[
          Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                image: const DecorationImage(
                  image: const AssetImage('assets/images/star.png'),
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
                image: const DecorationImage(
                  image: const AssetImage('assets/images/fork.png'),
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
          onPressed: () => {
                FocusScope.of(context).unfocus(),
                _homeBloc.fetchData(),
              }),
    );
  }

  @override
  void onNegativeButtonClicked(DialogType type, dynamic t) {
    print("onNegativeButtonClicked: $type, $t");
  }

  @override
  void onPositiveButtonClicked(DialogType type, dynamic t) {
    _homeBloc.deleteItemList(t as ModelEntity);
  }
}
