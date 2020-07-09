import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/data/entities/model_entity.dart';
import 'package:flutterapp/data/manager/data_manager.dart';
import 'package:flutterapp/di/inject.dart';
import 'package:flutterapp/extension/constants.dart';
import 'package:flutterapp/extension/string.dart';
import 'package:flutterapp/ui/extension/widget_extension.dart';
import 'package:flutterapp/ui/home/home_bloc.dart';

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
        appBar: buildAppBar(title: HOME_TITLE),
        backgroundColor: Colors.transparent,
        body: BlocProvider<HomeBloc>(
          create: (context) => _homeBloc..add(HomeFetchedDataEvent()), //todo
          child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {},
            child: Container(
              child: RefreshIndicator(
                onRefresh: () => _homeBloc.fetchData(),
                child: Stack(
                  children: <Widget>[
                    ListView(),
                    _buildStateView(),
                  ],
                ),
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
        return _buildError();
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

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildImageError(),
          buildSpacer(22),
          _buildTitleError(),
          buildSpacer(18),
          _buildSubtitleError(),
          buildSpacer(22),
          _buildButtonError(),
        ],
      ),
    );
  }

  Widget _buildListView() {
    final data = (_homeBloc.state as HomeSuccessState).entities;
    if (data.isEmpty) {
      return Container(); //todo
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {},
            child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildAvatarViewHolder(data[index]),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _buildAuthorViewHolder(data[index]),
                          _buildExpansionViewHolder(data[index]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: data.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
      ),
    );
  }

  Widget _buildAvatarViewHolder(ModelEntity model) {
    return Container(
        margin: const EdgeInsets.all(5.0),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(model.avatar),
            fit: BoxFit.fill,
          ),
          shape: BoxShape.circle,
        ));
  }

  Widget _buildAuthorViewHolder(ModelEntity model) {
    return Container(
      margin: const EdgeInsets.all(5.0),
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

  Widget _buildExpansionViewHolder(ModelEntity model) {
    return ExpansionTile(
      trailing: null,
      title: _buildNameViewHolder(model),
      /*children: <Widget>[
        Row(
          children: <Widget>[
            _buildLanguageViewHolder(model),
            _buildStarsViewHolder(model),
            _buildForksViewHolder(model),
          ],
        )
      ],*/
    );
  }

  Widget _buildNameViewHolder(ModelEntity model) {
    return Text(
      model.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
      style: TextStyle(
          color: const Color(0xFF52575C),
          fontSize: 16,
          fontFamily: 'RobotoReg'),
    );
  }

  Widget _buildDescriptionViewHolder(ModelEntity model) {
    return Text(
      model.description,
      textAlign: TextAlign.start,
      style: TextStyle(
        color: const Color(0xFF52575C),
        fontSize: 12,
        fontFamily: 'PingFang',
      ),
    );
  }

  Widget _buildLanguageViewHolder(ModelEntity model) {
    return Row(
      children: <Widget>[
        Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: model.languageColor.parseColor(),
              shape: BoxShape.circle,
            )),
        Expanded(
          child: Text(
            model.language,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: const Color(0xFF52575C),
              fontSize: 12,
              fontFamily: 'RobotoReg',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStarsViewHolder(ModelEntity model) {
    return Row(
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
        Expanded(
          child: Text(
            model.stars.toString(),
            textAlign: TextAlign.start,
            style: TextStyle(
              color: const Color(0xFF52575C),
              fontSize: 12,
              fontFamily: 'RobotoReg',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForksViewHolder(ModelEntity model) {
    return Row(
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
        Expanded(
          child: Text(
            model.forks.toString(),
            textAlign: TextAlign.start,
            style: TextStyle(
              color: const Color(0xFF52575C),
              fontSize: 12,
              fontFamily: 'RobotoReg',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageError() {
    return Container(
        width: 250,
        height: 250,
        decoration: const BoxDecoration(
          image: const DecorationImage(
            image: const AssetImage('assets/images/error.png'),
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

  Widget _buildSubtitleError() {
    return Text(
      HOME_ERROR_SUBTITLE,
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
