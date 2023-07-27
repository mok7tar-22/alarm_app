import 'package:alarm_app/views/widgets/alarm_list_view.dart';
import 'package:flutter/material.dart';

import '../widgets/add_alarm_widget.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alarm App"),
      ),
      body: Container(
          margin: const EdgeInsets.all(8), child: const AlarmListView()),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            showModalBottomSheet(
                isDismissible: false,
                enableDrag: false,
                context: context,
                builder: (context) {
                  return const AddAlarm();
                });
          },
          child: const Icon(
            Icons.add,
            size: 30,
          )),
    );
  }
}
