import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/alarm_model.dart';
import '../utils/alarm_fields.dart';

part 'date_base_state.dart';

class DateBaseCubit extends Cubit<DateBaseState> {
  DateBaseCubit._() : super(DateBaseInitial());
  static final DateBaseCubit instance = DateBaseCubit._();
  static Database? _database;
  List<AlarmModel> alarms = [];

  static DateBaseCubit get(context) => BlocProvider.of(context);
  Future<Database?> get db async {
    if (_database == null) {
      _database = await initialDb();
      return _database;
    } else {
      return _database;
    }
  }

  initialDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'alarm.db');
    Database mydb = await openDatabase(path, onCreate: _createDB, version: 1);
    return mydb;
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    // const integerType = 'INTEGER NOT NULL';
    await db.execute('''
CREATE TABLE $tableAlarm ( 
  ${AlarmFields.id} $idType, 
  ${AlarmFields.isActive} $boolType,
  ${AlarmFields.title} $textType,
  ${AlarmFields.alarmDateTime} $textType
  )
''');
    emit(AppCreateDatabaseState());
  }

  Future<AlarmModel?> insert(AlarmModel alarm) async {
    final myDateBase = await db;
    emit(AppInsertDatabaseLoadingState());
    try {
      final int id = await myDateBase!.insert(tableAlarm, alarm.toJson());
      emit(AppInsertDatabaseState());
      getAllAlarm();
      return alarm.copy(id: id);
    } catch (error) {
      emit(AppInsertDatabaseFailureState(error.toString()));
    }
    return null;
  }

  Future<List<AlarmModel>?> getAllAlarm() async {
    final myDateBase = await db;
    const orderBy = '${AlarmFields.alarmDateTime} DESC';
    try {
      emit(AppGetDatabaseLoadingState());
      final query = await myDateBase!.query(tableAlarm, orderBy: orderBy);
      alarms = query.map((e) => AlarmModel.fromJson(e)).toList();
      emit(AppGetDatabaseState());
      return alarms;
    } catch (e) {
      return null;
    }
  }

  Future<AlarmModel?> getAlarmById(int id) async {
    final myDateBase = await db;
    try {
      final query = await myDateBase!
          .query(tableAlarm, where: '${AlarmFields.id} = ?', whereArgs: [id]);
      if (query.isNotEmpty) {
        final alarm = AlarmModel.fromJson(query.first);
        return alarm;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<int?> update(AlarmModel alarmModel) async {
    final dataBase = await db;
    emit(AppUpdateDatabaseState());
    return dataBase!.update(
      tableAlarm,
      alarmModel.toJson(),
      where: '${AlarmFields.id} = ?',
      whereArgs: [alarmModel.id],
    ).then((value) {
      getAllAlarm();
      return null;
    });
  }

  Future<int?> delete(int id) async {
    final dataBase = await db;

    return await dataBase!.delete(
      tableAlarm,
      where: '${AlarmFields.id} = ?',
      whereArgs: [id],
    ).then((value) {
      getAllAlarm();
      emit(AppDeleteDatabaseState());
      return null;
    });
  }
}
// Future<int?> updateIsActive(int id, bool isActive) async {
//   final dataBase = await _database;
//   final result = await dataBase!.update(
//     tableAlarm,
//     {AlarmFields.isActive: isActive ? 1 : 0}, // update isActive parameter
//     where: '${AlarmFields.id} = ?',
//     whereArgs: [id],
//   );
//   getAllAlarm();
//   return result;
// }
