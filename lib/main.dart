import 'package:alarm_app/services/notification_services.dart';
import 'package:alarm_app/views/screens/alarm_screen.dart';
import 'package:alarm_app/views/screens/stop_alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'controllers/date_base_cubit.dart';
import 'observer.dart';

void main() async {
  Bloc.observer = MyBlocObserver();

  await NotificationService.initializeNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DateBaseCubit.instance
        ..initialDb()
        ..getAllAlarm(),
      child: MaterialApp(
        title: 'Notes App',
        navigatorKey: StopAlarm.navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(
          useMaterial3: true,
        ),
        home: const AlarmScreen(),
      ),
    );
  }
}
