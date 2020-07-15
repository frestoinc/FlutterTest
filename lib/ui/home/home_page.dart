import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/data/manager/data_manager.dart';
import 'package:flutterapp/di/inject.dart';
import 'package:flutterapp/extension/constants.dart';
import 'package:flutterapp/ui/authentication/authentication.dart';
import 'package:flutterapp/ui/home/home.dart';
import 'package:flutterapp/ui/home/home_content.dart';

class HomePage extends StatelessWidget {
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
            PopupMenuButton<int>(
              padding: EdgeInsets.zero,
              onSelected: (int) => {
                //todo
                int == 2
                    ? BlocProvider.of<AuthenticationBloc>(context)
                        .add(AuthenticationLoggedOutEvent())
                    : print("todo"),
              },
              itemBuilder: (context) => <PopupMenuEntry<int>>[
                PopupMenuItem<int>(
                  value: 1,
                  child: Text("Sort"),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Text("LOG OUT"),
                ),
              ],
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        body: BlocProvider(
          create: (context) {
            return HomeBloc(
                manager: getIt<DataManager>(),
                authBloc: BlocProvider.of<AuthenticationBloc>(context))
              ..add(HomeFetchedDataEvent());
          },
          child: HomeContent(),
        ),
      ),
    );
  }
}
