import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fastter/fastter_bloc.dart';
import '../helpers/todofilters.dart';
import '../models/base.model.dart';
import '../models/todo.model.dart';
import '../store/todos.dart';

class FilterCountText extends StatelessWidget {
  const FilterCountText(
    this.filter,
  );
  final Map<String, dynamic> filter;
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FastterBloc<Todo>, ListState<Todo>>(
        bloc: fastterTodos,
        builder: (context, state) =>
            Text(filterToCount(filter, state).toString()),
      );
}
