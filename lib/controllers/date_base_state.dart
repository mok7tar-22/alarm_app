part of 'date_base_cubit.dart';

@immutable
abstract class DateBaseState {}

class DateBaseInitial extends DateBaseState {}

class AppCreateDatabaseState extends DateBaseState {}

class AppGetDatabaseLoadingState extends DateBaseState {}

class AppGetDatabaseState extends DateBaseState {}

class AppInsertDatabaseLoadingState extends DateBaseState {}

class AppInsertDatabaseState extends DateBaseState {}

class AppInsertDatabaseFailureState extends DateBaseState {
  final String error;

  AppInsertDatabaseFailureState(this.error);
}

class AppUpdateDatabaseState extends DateBaseState {}

class AppDeleteDatabaseState extends DateBaseState {}

class SearchState extends DateBaseState {}
