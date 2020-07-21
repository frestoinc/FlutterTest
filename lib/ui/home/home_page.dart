import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/ui/authentication/authentication_bloc.dart';
import 'package:flutterapp/ui/home/home_bloc.dart';
import 'package:flutterapp/ui/home/home_content.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: BlocProvider(
        create: (context) {
          return HomeBloc(
              authBloc: BlocProvider.of<AuthenticationBloc>(context))
            ..add(HomeFetchedDataEvent());
        },
        child: HomeContent(),
      ),
    );
  }
}
