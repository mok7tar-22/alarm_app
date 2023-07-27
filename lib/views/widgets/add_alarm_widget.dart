import 'package:alarm_app/models/alarm_model.dart';
import 'package:alarm_app/utils/show_error_widget.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/date_base_cubit.dart';
import '../../services/notification_services.dart';

class AddAlarm extends StatefulWidget {
  const AddAlarm({Key? key}) : super(key: key);

  @override
  State<AddAlarm> createState() => _AddAlarmState();
}

class _AddAlarmState extends State<AddAlarm> {
  TextEditingController titleController = TextEditingController();
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  DateTime dateTime = DateTime.now();

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  TimeOfDay selectedTime = TimeOfDay.now();
  bool isAdding = false;
  final now = DateTime.now();
  DateTime applied(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime.utc(now.year, now.month, now.day, time.hour, time.minute);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DateBaseCubit, DateBaseState>(
      listener: (context, state) {
        if (state is AppInsertDatabaseState) {
          Navigator.pop(context);
        } else if (state is AppInsertDatabaseFailureState) {
          showError(body: state.error, context: context);
        } else {
          const CircularProgressIndicator();
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30).add(
              EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom)),
          //margin: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              color: Theme.of(context).bottomSheetTheme.backgroundColor,
              borderRadius: BorderRadius.circular(8)),
          child: Form(
            key: form,
            child: Column(children: [
              const Text("Add Alarm"),
              TextFormField(
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    return null;
                  } else {
                    return "'Field is required '";
                  }
                },
                enabled: !isAdding,
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  labelStyle: TextStyle(fontSize: 25),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              const SizedBox(height: 15),
              const Align(
                  alignment: Alignment.centerLeft, child: Text("Chosse Time")),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue)),
                onPressed: isAdding
                    ? null
                    : () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());
                        if (pickedTime != null) {
                          selectedTime = pickedTime;
                          dateTime = applied(selectedTime);
                          setState(() {});
                          print("$selectedTime---$dateTime");
                        }
                      },
                child: Text(
                  selectedTime.format(context),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "cancle",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue)),
                      onPressed: () {
                        if (form.currentState!.validate()) {
                          DateBaseCubit.get(context)
                              .insert(AlarmModel(
                                  title: titleController.text,
                                  isActive: true,
                                  alarmDateTime: dateTime))
                              .then((value) {
                            NotificationService.showNotification(
                                id: value!.id!,
                                title: titleController.text,
                                body: "Alarm",
                                scheduledDate: DateTime(
                                    now.year,
                                    now.month,
                                    now.day,
                                    selectedTime.hour,
                                    selectedTime.minute),
                                payload: {
                                  "navigate": "true",
                                },
                                actionButtons: [
                                  NotificationActionButton(
                                    key: 'check',
                                    label: 'Go To Alarm',
                                    color: Colors.green,
                                  )
                                ]);
                          });
                        }
                      },
                      child: const Text(
                        "Add",
                      )),
                ],
              ),
            ]),
          ),
        ));
      },
    );
  }
}
