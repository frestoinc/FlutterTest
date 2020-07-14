import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/data/entities/model_entity.dart';
import 'package:flutterapp/data/manager/data_manager.dart';
import 'package:flutterapp/di/inject.dart';
import 'package:flutterapp/extension/constants.dart';
import 'package:flutterapp/extension/string.dart';
import 'package:flutterapp/ui/extension/widget_extension.dart';

import 'home_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc _homeBloc;

  @override
  void initState() {
    _homeBloc = HomeBloc(manager: getIt<DataManager>());
    super.initState();
  }

  @override
  void dispose() {
    _homeBloc.close();
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
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/background.jpg'),
                        fit: BoxFit.cover)),
              ),
              ListTile()
            ],
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
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              /*onSelected: (value) => showInSnackBar(GalleryLocalizations.of(context).demoMenuSelected(value)),*/
              itemBuilder: (context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: "",
                  child: Text("ABC"),
                ),
                PopupMenuItem<String>(
                  enabled: false,
                  value: "",
                  child: Text("DEF"),
                ),
                PopupMenuItem<String>(
                  enabled: false,
                  value: "",
                  child: Text("GHI"),
                ),
              ],
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        body: BlocProvider<HomeBloc>(
          create: (context) => _homeBloc..add(HomeFetchedDataEvent()),
          child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {},
            child: Container(
              child: RefreshIndicator(
                onRefresh: () => _homeBloc.fetchData(),
                child: _buildStateView(),
              ),
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
      } else if (state is HomeFailureState) {
        return _buildError(true);
      } else if (state is HomeSuccessState) {
        return _buildListView();
      } else {
        return Container();
      }
    });
  }

  Widget _buildLoadingProgress() {
    return Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: CircularProgressIndicator(
          strokeWidth: 8.0,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF31B057)),
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
    final data = (_homeBloc.state as HomeSuccessState).entities;
    if (data.isEmpty) {
      return _buildError(false);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return ExpansionTile(
              trailing: Icon(Icons.more_vert),
              leading: _buildAvatarViewHolder(data[index]),
              title: _buildAuthorViewHolder(data[index]),
              subtitle: _buildNameViewHolder(data[index]),
              children: <Widget>[
                _buildBody(data[index]),
              ],
            );
          }),
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
}
