import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/data/manager/data_manager.dart';
import 'package:flutterapp/di/inject.dart';
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
      child: BlocProvider(
        create: (context) {
          return HomeBloc(
              manager: getIt<DataManager>(),
              authBloc: BlocProvider.of<AuthenticationBloc>(context))
            ..add(HomeFetchedDataEvent());
        },
        child: HomeContent(),
      ),
    );
  }
}
