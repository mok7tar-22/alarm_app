import 'package:alarm_app/models/alarm_model.dart';
import 'package:alarm_app/views/widgets/alarm_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controllers/date_base_cubit.dart';

class AlarmListView extends StatelessWidget {
  const AlarmListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateBaseCubit, DateBaseState>(
      builder: (context, state) {
        List<AlarmModel> alarms = DateBaseCubit.instance.alarms;
        if (state is AppGetDatabaseLoadingState) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        return alarms.isNotEmpty
            ? ListView.builder(
                itemCount: alarms.length,
                itemBuilder: (context, index) {
                  return AlarmItem(alarmModel: alarms[index]);
                },
              )
            : const Center(
                child: Text("Add Alarm"),
              );
      },
    );
  }
}
