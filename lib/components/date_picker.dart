// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart'
    show
        ButtonBar,
        ButtonTheme,
        Colors,
        debugCheckHasMaterialLocalizations,
        Dialog,
        showDialog,
        Feedback,
        FlatButton,
        MonthPicker,
        YearPicker,
        InkWell,
        ListTile,
        Material,
        MaterialType,
        kMaterialEdges,
        MaterialLocalizations,
        TextTheme,
        Theme,
        ThemeData,
        Icons;

/// Initial display mode of the date picker dialog.
///
/// Date picker UI mode for either showing a list of available years or a
/// monthly calendar initially in the dialog shown by calling [showDatePicker].
///
/// See also:
///
///  * [showDatePicker], which shows a dialog that contains a material design
///    date picker.
enum DatePickerMode {
  /// Show a date picker UI for choosing a month and day.
  day,

  /// Show a date picker UI for choosing a year.
  year,
}

class DatePickerResponse {
  DatePickerResponse(this.dateTime);

  DateTime dateTime;
}

const double _kDatePickerHeaderPortraitHeight = 100.0;
const double _kDatePickerHeaderLandscapeWidth = 168.0;

const double _kDayPickerRowHeight = 42.0;
const int _kMaxDayPickerRowCount = 6; // A 31 day month that starts on Saturday.
// Two extra rows: one for the day-of-week header and one for the month header.
const double _kMaxDayPickerHeight =
    _kDayPickerRowHeight * (_kMaxDayPickerRowCount + 2);

const double _kMonthPickerPortraitWidth = 330.0;
const double _kMonthPickerLandscapeWidth = 344.0;

const double _kDialogActionBarHeight = 52.0;
const double _kDatePickerLandscapeHeight =
    _kMaxDayPickerHeight + _kDialogActionBarHeight + 12;

class _DatePickerQuickPickers extends StatelessWidget {
  final ValueChanged<DateTime> onChanged;
  final DateTime selectedDate;
  final DatePickerMode mode;
  final ValueChanged<DatePickerMode> onModeChanged;

  _DatePickerQuickPickers({
    @required this.onChanged,
    @required this.selectedDate,
    @required this.mode,
    @required this.onModeChanged,
    Key key,
  })  : assert(selectedDate != null),
        assert(mode != null),
        super(key: key);

  bool isToday() {
    final now = DateTime.now();
    final diff = selectedDate.difference(now);
    if (diff.inDays > -2 && diff.inDays < 2) {
      if (selectedDate.day == now.day) {
        return true;
      }
    }
    return false;
  }

  bool isTomorrow() {
    final now = DateTime.now();
    final diff = selectedDate.difference(now);
    if (diff.inDays > -2 && diff.inDays < 2) {
      if (selectedDate.day == now.day + 1) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            dense: true,
            leading: Icon(Icons.calendar_today),
            selected: isToday(),
            title: Text("Today"),
            onTap: () {
              onChanged(DateTime.now());
            },
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.calendar_view_day),
            selected: isTomorrow(),
            title: Text("Tomorrow"),
            onTap: () {
              onChanged(DateTime.now().add(const Duration(days: 1)));
            },
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.cancel),
            title: Text("Remove Date"),
            onTap: () {
              Navigator.pop(context, DatePickerResponse(null));
            },
          ),
        ],
      ),
    );
  }
}

// Shows the selected date in large font and toggles between year and day mode
class _DatePickerHeader extends StatelessWidget {
  const _DatePickerHeader({
    Key key,
    @required this.selectedDate,
    @required this.mode,
    @required this.onModeChanged,
  })  : assert(selectedDate != null),
        assert(mode != null),
        super(key: key);

  final DateTime selectedDate;
  final DatePickerMode mode;
  final ValueChanged<DatePickerMode> onModeChanged;

  void _handleChangeMode(DatePickerMode value) {
    if (value != mode) onModeChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final ThemeData themeData = Theme.of(context);
    final TextTheme headerTextTheme = themeData.primaryTextTheme;
    Color dayColor;
    Color yearColor;
    switch (themeData.primaryColorBrightness) {
      case Brightness.light:
        dayColor = mode == DatePickerMode.day ? Colors.black87 : Colors.black54;
        yearColor =
            mode == DatePickerMode.year ? Colors.black87 : Colors.black54;
        break;
      case Brightness.dark:
        dayColor = mode == DatePickerMode.day ? Colors.white : Colors.white70;
        yearColor = mode == DatePickerMode.year ? Colors.white : Colors.white70;
        break;
    }
    final TextStyle dayStyle =
        headerTextTheme.display1.copyWith(color: dayColor, height: 1.4);
    final TextStyle yearStyle =
        headerTextTheme.subhead.copyWith(color: yearColor, height: 1.4);

    Color backgroundColor;
    switch (themeData.brightness) {
      case Brightness.light:
        backgroundColor = themeData.primaryColor;
        break;
      case Brightness.dark:
        backgroundColor = themeData.backgroundColor;
        break;
    }

    double width;
    double height;
    EdgeInsets padding;
    MainAxisAlignment mainAxisAlignment;
    switch (MediaQuery.of(context).orientation) {
      case Orientation.portrait:
        height = _kDatePickerHeaderPortraitHeight;
        padding = const EdgeInsets.symmetric(horizontal: 16.0);
        mainAxisAlignment = MainAxisAlignment.center;
        break;
      case Orientation.landscape:
        width = _kDatePickerHeaderLandscapeWidth;
        padding = const EdgeInsets.all(8.0);
        mainAxisAlignment = MainAxisAlignment.start;
        break;
    }

    final Widget yearButton = IgnorePointer(
      ignoring: mode != DatePickerMode.day,
      ignoringSemantics: false,
      child: _DateHeaderButton(
        color: backgroundColor,
        onTap: Feedback.wrapForTap(
            () => _handleChangeMode(DatePickerMode.year), context),
        child: Semantics(
          selected: mode == DatePickerMode.year,
          child: Text(localizations.formatYear(selectedDate), style: yearStyle),
        ),
      ),
    );

    final Widget dayButton = IgnorePointer(
      ignoring: mode == DatePickerMode.day,
      ignoringSemantics: false,
      child: _DateHeaderButton(
        color: backgroundColor,
        onTap: Feedback.wrapForTap(
            () => _handleChangeMode(DatePickerMode.day), context),
        child: Semantics(
          selected: mode == DatePickerMode.day,
          child: Text(localizations.formatMediumDate(selectedDate),
              style: dayStyle),
        ),
      ),
    );

    return Container(
      width: width,
      height: height,
      padding: padding,
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          yearButton,
          dayButton,
        ],
      ),
    );
  }
}

class _DateHeaderButton extends StatelessWidget {
  const _DateHeaderButton({
    Key key,
    this.onTap,
    this.color,
    this.child,
  }) : super(key: key);

  final VoidCallback onTap;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Material(
      type: MaterialType.button,
      color: color,
      child: InkWell(
        borderRadius: kMaterialEdges[MaterialType.button],
        highlightColor: theme.highlightColor,
        splashColor: theme.splashColor,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: child,
        ),
      ),
    );
  }
}

class _DatePickerDialog extends StatefulWidget {
  const _DatePickerDialog({
    Key key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate,
    this.initialDatePickerMode,
  }) : super(key: key);

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final SelectableDayPredicate selectableDayPredicate;
  final DatePickerMode initialDatePickerMode;

  @override
  _DatePickerDialogState createState() => _DatePickerDialogState();
}

class _DatePickerDialogState extends State<_DatePickerDialog> {
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _mode = widget.initialDatePickerMode;
  }

  DateTime _selectedDate;
  DatePickerMode _mode;
  final GlobalKey _pickerKey = GlobalKey();

  bool _announcedInitialDate = false;

  MaterialLocalizations localizations;
  TextDirection textDirection;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = MaterialLocalizations.of(context);
    textDirection = Directionality.of(context);
    if (!_announcedInitialDate) {
      _announcedInitialDate = true;
      SemanticsService.announce(
        localizations.formatFullDate(_selectedDate),
        textDirection,
      );
    }
  }

  void _vibrate() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        HapticFeedback.vibrate();
        break;
      case TargetPlatform.iOS:
        break;
    }
  }

  void _handleModeChanged(DatePickerMode mode) {
    _vibrate();
    setState(() {
      _mode = mode;
      if (_mode == DatePickerMode.day) {
        SemanticsService.announce(
            localizations.formatMonthYear(_selectedDate), textDirection);
      } else {
        SemanticsService.announce(
            localizations.formatYear(_selectedDate), textDirection);
      }
    });
  }

  void _handleYearChanged(DateTime value) {
    if (value.isBefore(widget.firstDate))
      value = widget.firstDate;
    else if (value.isAfter(widget.lastDate)) value = widget.lastDate;
    if (value == _selectedDate) return;

    _vibrate();
    setState(() {
      _mode = DatePickerMode.day;
      _selectedDate = value;
    });
  }

  void _handleDayChanged(DateTime value) {
    _vibrate();
    setState(() {
      _selectedDate = value;
    });
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  void _handleOk() {
    Navigator.pop(context, DatePickerResponse(_selectedDate));
  }

  Widget _buildPicker() {
    assert(_mode != null);
    switch (_mode) {
      case DatePickerMode.day:
        return Column(
          children: [
            MonthPicker(
              key: _pickerKey,
              selectedDate: _selectedDate,
              onChanged: _handleDayChanged,
              firstDate: widget.firstDate,
              lastDate: widget.lastDate,
              selectableDayPredicate: widget.selectableDayPredicate,
            ),
          ],
        );
      case DatePickerMode.year:
        return YearPicker(
          key: _pickerKey,
          selectedDate: _selectedDate,
          onChanged: _handleYearChanged,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
        );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Widget picker = Flexible(
      child: SizedBox(
        height: _kMaxDayPickerHeight,
        child: _buildPicker(),
      ),
    );
    final Widget actions = ButtonTheme.bar(
      child: ButtonBar(
        children: <Widget>[
          FlatButton(
            child: Text(localizations.cancelButtonLabel),
            onPressed: _handleCancel,
          ),
          FlatButton(
            child: Text(localizations.okButtonLabel),
            onPressed: _handleOk,
          ),
        ],
      ),
    );
    final mediaQueryData = MediaQuery.of(context);
    final Widget header = _DatePickerHeader(
      selectedDate: _selectedDate,
      mode: _mode,
      onModeChanged: _handleModeChanged,
    );
    final Widget quickPickers = _DatePickerQuickPickers(
      onChanged: _handleDayChanged,
      selectedDate: _selectedDate,
      mode: _mode,
      onModeChanged: _handleModeChanged,
    );
    final Dialog dialog = Dialog(
      child: mediaQueryData.orientation == Orientation.portrait
          ? SizedBox(
              width: _kMonthPickerPortraitWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  header,
                  quickPickers,
                  Container(
                    color: theme.dialogBackgroundColor,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        picker,
                        actions,
                      ],
                    ),
                  ),
                ],
              ),
            )
          : SizedBox(
              height: _kDatePickerLandscapeHeight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    width: _kMonthPickerLandscapeWidth,
                    color: theme.dialogBackgroundColor,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[header, quickPickers],
                    ),
                  ),
                  // header,
                  Flexible(
                    child: Container(
                      width: _kMonthPickerLandscapeWidth,
                      color: theme.dialogBackgroundColor,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[picker, actions],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );

    return Theme(
      data: theme.copyWith(
        dialogBackgroundColor: Colors.transparent,
      ),
      child: dialog,
    );
  }
}

/// Signature for predicating dates for enabled date selections.
///
/// See [showDatePicker].
typedef SelectableDayPredicate = bool Function(DateTime day);

/// Shows a dialog containing a material design date picker.
///
/// The returned [Future] resolves to the date selected by the user when the
/// user closes the dialog. If the user cancels the dialog, null is returned.
///
/// An optional [selectableDayPredicate] function can be passed in to customize
/// the days to enable for selection. If provided, only the days that
/// [selectableDayPredicate] returned true for will be selectable.
///
/// An optional [initialDatePickerMode] argument can be used to display the
/// date picker initially in the year or month+day picker mode. It defaults
/// to month+day, and must not be null.
///
/// An optional [locale] argument can be used to set the locale for the date
/// picker. It defaults to the ambient locale provided by [Localizations].
///
/// An optional [textDirection] argument can be used to set the text direction
/// (RTL or LTR) for the date picker. It defaults to the ambient text direction
/// provided by [Directionality]. If both [locale] and [textDirection] are not
/// null, [textDirection] overrides the direction chosen for the [locale].
///
/// The [context] argument is passed to [showDialog], the documentation for
/// which discusses how it is used.
///
/// The [builder] parameter can be used to wrap the dialog widget
/// to add inherited widgets like [Theme].
///
/// {@tool sample}
/// Show a date picker with the dark theme.
///
/// ```dart
/// Future<DateTime> selectedDate = showDatePicker(
///   context: context,
///   initialDate: DateTime.now(),
///   firstDate: DateTime(2018),
///   lastDate: DateTime(2030),
///   builder: (BuildContext context, Widget child) {
///     return Theme(
///       data: ThemeData.dark(),
///       child: child,
///     );
///   },
/// );
/// ```
/// {@end-tool}
///
/// The [context], [initialDate], [firstDate], and [lastDate] parameters must
/// not be null.
///
/// See also:
///
///  * [showTimePicker], which shows a dialog that contains a material design
///    time picker.
///  * [DayPicker], which displays the days of a given month and allows
///    choosing a day.
///  * [MonthPicker], which displays a scrollable list of months to allow
///    picking a month.
///  * [YearPicker], which displays a scrollable list of years to allow picking
///    a year.
Future<DatePickerResponse> showDatePicker({
  @required BuildContext context,
  @required DateTime initialDate,
  @required DateTime firstDate,
  @required DateTime lastDate,
  SelectableDayPredicate selectableDayPredicate,
  DatePickerMode initialDatePickerMode = DatePickerMode.day,
  Locale locale,
  TextDirection textDirection,
  TransitionBuilder builder,
}) async {
  assert(initialDate != null);
  assert(firstDate != null);
  assert(lastDate != null);
  assert(!initialDate.isBefore(firstDate),
      'initialDate must be on or after firstDate');
  assert(!initialDate.isAfter(lastDate),
      'initialDate must be on or before lastDate');
  assert(
      !firstDate.isAfter(lastDate), 'lastDate must be on or after firstDate');
  assert(selectableDayPredicate == null || selectableDayPredicate(initialDate),
      'Provided initialDate must satisfy provided selectableDayPredicate');
  assert(
      initialDatePickerMode != null, 'initialDatePickerMode must not be null');
  assert(context != null);
  assert(debugCheckHasMaterialLocalizations(context));

  Widget child = _DatePickerDialog(
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    selectableDayPredicate: selectableDayPredicate,
    initialDatePickerMode: initialDatePickerMode,
  );

  if (textDirection != null) {
    child = Directionality(
      textDirection: textDirection,
      child: child,
    );
  }

  if (locale != null) {
    child = Localizations.override(
      context: context,
      locale: locale,
      child: child,
    );
  }

  return await showDialog<DatePickerResponse>(
    context: context,
    builder: (BuildContext context) {
      return builder == null ? child : builder(context, child);
    },
  );
}
