import '../models/user.model.dart';
import 'package:fastter_todo/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/settings.model.dart';
import '../store/user.dart';

import 'home/router.dart';

class HomeContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<UserBloc, UserState>(
        bloc: fastterUser,
        builder: (context, state) => HomePage(
          frontPage: state.user?.settings?.frontPage ??
              FrontPage(
                route: '/',
                title: 'Inbox',
              ),
        ),
      );
}
