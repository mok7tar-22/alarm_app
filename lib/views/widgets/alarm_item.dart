import 'package:alarm_app/controllers/date_base_cubit.dart';
import 'package:alarm_app/models/alarm_model.dart';
import 'package:alarm_app/views/screens/edit_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AlarmItem extends StatefulWidget {
  AlarmModel alarmModel;

  AlarmItem({required this.alarmModel, Key? key}) : super(key: key);

  @override
  State<AlarmItem> createState() => _AlarmItemState();
}

class _AlarmItemState extends State<AlarmItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        margin: const EdgeInsets.only(bottom: 10),
        child: Slidable(
          startActionPane: ActionPane(
            extentRatio: 0.25,
            motion: const BehindMotion(),
            children: [
              Expanded(
                child: InkWell(
                    onTap: () async {
                      await DateBaseCubit.get(context)
                          .delete(widget.alarmModel.id!);
                      AwesomeNotifications().cancel(widget.alarmModel.id!);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.red,
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30,
                          ),
                          Text("Delete"),
                        ],
                      ),
                    )),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EditScreen(alarmModel: widget.alarmModel)),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).bottomAppBarTheme.color,
              ),
              padding: const EdgeInsets.all(10),
              //margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: ListTile(
                horizontalTitleGap: 0,
                leading: VerticalDivider(
                  thickness: 4,
                  color: widget.alarmModel.isActive
                      ? Colors.green
                      : Theme.of(context).primaryColor,
                ),
                title: Text(
                  widget.alarmModel.title,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.timer,
                        size: 14,
                      ),
                      Text(
                        "${widget.alarmModel.alarmDateTime.hour.toString()}:${widget.alarmModel.alarmDateTime.minute.toString()}",
                        style: TextStyle(color: Colors.black38, fontSize: 25),
                      ),
                    ],
                  ),
                ),
                // DateFormat('hh:mm a').format( task[index]["dateTime"]
                trailing: const Text(
                  "Active",
                  style: TextStyle(color: Colors.green, fontSize: 25),
                ),
              ),
            ),
          ),
        ));
  }
}
