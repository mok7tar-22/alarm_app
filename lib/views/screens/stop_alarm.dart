import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import '../../controllers/date_base_cubit.dart';
import '../../services/notification_services.dart';

class StopAlarm extends StatefulWidget {
  int id;

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  StopAlarm({required this.id, Key? key}) : super(key: key);

  @override
  State<StopAlarm> createState() => _StopAlarmState();
}

class _StopAlarmState extends State<StopAlarm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Alarm"), automaticallyImplyLeading: false),
      body: Center(
        child: Column(
          children: [
            Image.asset("assets/images/alarm.png"),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      AwesomeNotifications().cancel(widget.id).then((value) {
                        NotificationService.showNotification(
                            id: widget.id,
                            title: "Alarm",
                            body: "WakeUp",
                            scheduledDate:
                                DateTime.now().add(const Duration(seconds: 10)),
                            payload: {
                              "navigate": "true",
                            },
                            actionButtons: [
                              NotificationActionButton(
                                key: 'check',
                                label: 'Check it out',
                                color: Colors.green,
                              )
                            ]).then((value) {
                          Navigator.pop(context);
                        });
                      });
                    },
                    child: Text("sleep")),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      DateBaseCubit.get(context).delete(widget.id);
                      AwesomeNotifications().cancel(widget.id);
                      Navigator.pop(context);
                    },
                    child: Text("Cancle")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
