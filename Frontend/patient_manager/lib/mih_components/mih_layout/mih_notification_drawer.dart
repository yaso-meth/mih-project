import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/mih_objects/app_user.dart';
import 'package:patient_manager/mih_objects/notification.dart';

class MIHNotificationDrawer extends StatefulWidget {
  final AppUser signedInUser;
  final List<MIHNotification> notifications;
  //final ImageProvider<Object>? propicFile;

  const MIHNotificationDrawer({
    super.key,
    required this.signedInUser,
    required this.notifications,
  });

  @override
  State<MIHNotificationDrawer> createState() => _MIHNotificationDrawerState();
}

class _MIHNotificationDrawerState extends State<MIHNotificationDrawer> {
  late List<List<String>> notificationList;

  List<List<String>> setTempNofitications() {
    List<List<String>> temp = [];
    temp.add(["Notification 1", "Notification Description 1"]);
    temp.add(["Notification 2", "Notification Description 2"]);
    temp.add(["Notification 3", "Notification Description 3"]);
    temp.add(["Notification 4", "Notification Description 4"]);
    temp.add(["Notification 5", "Notification Description 5"]);
    temp.add(["Notification 6", "Notification Description 6"]);
    temp.add(["Notification 7", "Notification Description 7"]);
    temp.add(["Notification 8", "Notification Description 8"]);
    temp.add(["Notification 9", "Notification Description 9"]);
    temp.add(["Notification 10", "Notification Description 10"]);
    return temp;
  }

  Widget displayTempNotifications(int index) {
    String title = notificationList[index][0];
    String subtitle = notificationList[index][1];
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        ),
      ),
      onTap: () {
        //viewApprovalPopUp(index);
      },
    );
  }

  Widget displayNotifications(int index) {
    String title = widget.notifications[index].notification_type;
    String subtitle = widget.notifications[index].notification_message;
    Widget notificationTitle;
    if (widget.notifications[index].notification_read == "No") {
      notificationTitle = Row(
        children: [
          const Icon(Icons.circle_notifications),
          const SizedBox(
            width: 5,
          ),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              ),
            ),
          ),
        ],
      );
    } else {
      notificationTitle = Row(
        children: [
          //const Icon(Icons.circle_notifications),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              ),
            ),
          ),
        ],
      );
    }
    return ListTile(
      title: notificationTitle,
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        ),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(
          widget.notifications[index].action_path,
          arguments: widget.signedInUser,
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      notificationList = setTempNofitications();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        //backgroundColor:  MzanziInnovationHub.of(context)!.theme.primaryColor(),
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "Notifications",
                    style: TextStyle(
                      color:
                          MzanziInnovationHub.of(context)!.theme.primaryColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (BuildContext context, index) {
              return Divider(
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              );
            },
            itemCount: widget.notifications.length,
            itemBuilder: (context, index) {
              //final patient = widget.patients[index].id_no.contains(widget.searchString);
              //print(index);
              return displayNotifications(index);
            },
          ),
        ],
      ),
    ));
  }
}
