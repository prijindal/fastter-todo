import 'package:fastter_dart/fastter/fastter_bloc.dart';
import 'package:fastter_dart/store/todos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/models/todo.model.dart';

import '../helpers/todofilters.dart';

class FilterCountText extends StatelessWidget {
  const FilterCountText(
    this.filter,
  );
  final Map<String, dynamic> filter;
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FastterEvent<Todo>, ListState<Todo>>(
        bloc: fastterTodos,
        builder: (context, state) =>
            Text(filterToCount(filter, state).toString()),
      );
}
