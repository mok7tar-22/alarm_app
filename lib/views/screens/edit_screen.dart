import 'package:alarm_app/models/alarm_model.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import '../../controllers/date_base_cubit.dart';
import '../../services/notification_services.dart';

class EditScreen extends StatefulWidget {
  AlarmModel alarmModel;
  EditScreen({required this.alarmModel, Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController titleController = TextEditingController();
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime? time;

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    titleController.text = widget.alarmModel.title;
    time = widget.alarmModel.alarmDateTime;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Edit Screen",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            //margin: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: Theme.of(context).bottomSheetTheme.backgroundColor,
                borderRadius: BorderRadius.circular(8)),
            child: Form(
              key: form,
              child: Column(children: [
                TextFormField(
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      return null;
                    } else {
                      return "'Field is required '";
                    }
                  },
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    labelStyle: TextStyle(fontSize: 25),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                const SizedBox(height: 15),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Chosse Time")),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue)),
                  onPressed: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                        context: context, initialTime: TimeOfDay.now());
                    if (pickedTime != null) {
                      // TasksCubit.get(context).changeSelectedDay(selectedDate);
                      selectedTime = pickedTime;

                      setState(() {});
                      print("$selectedTime---$pickedTime");
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
                        // Navigator.of(context).pop();
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
                                .update(AlarmModel(
                                    id: widget.alarmModel.id,
                                    title: titleController.text,
                                    isActive: true,
                                    alarmDateTime: DateTime.now()))
                                .then((value) {
                              NotificationService.showNotification(
                                  id: widget.alarmModel.id!,
                                  title: titleController.text,
                                  body: "Alarm",
                                  scheduledDate: DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day,
                                      selectedTime.hour,
                                      selectedTime.minute),
                                  payload: {
                                    "navigate": "true",
                                  },
                                  actionButtons: [
                                    NotificationActionButton(
                                      key: 'check',
                                      label: 'Check it out',
                                      color: Colors.green,
                                    )
                                  ]);
                            }).catchError((e) {
                              print(e.toString());
                            });

                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          "Update",
                        )),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
