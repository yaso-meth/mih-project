import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_objects/notification.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:supertokens_flutter/http.dart' as http;

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
  final baseAPI = AppEnviroment.baseApiUrl;
  Future<void> updateNotificationAPICall(int index) async {
    var response = await http.put(
      Uri.parse(
          "$baseAPI/notifications/update/${widget.notifications[index].idnotifications}"),
    );
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(
        "/",
        arguments: AuthArguments(true, false),
      );
      Navigator.of(context).pushNamed(
        widget.notifications[index].action_path,
        arguments: widget.signedInUser,
      );
    } else {
      MihAlertServices().internetConnectionLost(context);
    }
  }

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
          color: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        ),
      ),
      onTap: () {},
    );
  }

  Widget displayNotifications(int index) {
    String title = widget.notifications[index].notification_type;
    String subtitle =
        "${widget.notifications[index].insert_date}\n${widget.notifications[index].notification_message}";
    Widget notificationTitle;
    if (widget.notifications[index].notification_read == "No") {
      notificationTitle = Row(
        children: [
          Icon(
            Icons.circle_notifications,
            color: MihColors.getRedColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
          color: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        ),
      ),
      onTap: () {
        if (widget.notifications[index].notification_read == "No") {
          updateNotificationAPICall(index);
        } else {
          Navigator.of(context).pushNamed(
            widget.notifications[index].action_path,
            arguments: widget.signedInUser,
          );
        }
      },
    );
  }

  Widget displayNotification() {
    if (widget.notifications.isNotEmpty) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (BuildContext context, index) {
          return Divider(
            color: MihColors.getSecondaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          );
        },
        itemCount: widget.notifications.length,
        itemBuilder: (context, index) {
          //final patient = widget.patients[index].id_no.contains(widget.searchString);
          //print(index);
          return displayNotifications(index);
        },
      );
    } else {
      return const Padding(
        padding: EdgeInsets.only(top: 35),
        child: Text(
          "No Notifications",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      );
    }
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
    return SafeArea(
      child: Drawer(
          //backgroundColor:  MihColors.getPrimaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Notifications",
                      style: TextStyle(
                        color: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            displayNotification(),
            // ListView.separated(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   separatorBuilder: (BuildContext context, index) {
            //     return Divider(
            //       color: MihColors.getSecondaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            //     );
            //   },
            //   itemCount: widget.notifications.length,
            //   itemBuilder: (context, index) {
            //     //final patient = widget.patients[index].id_no.contains(widget.searchString);
            //     //print(index);
            //     return displayNotifications(index);
            //   },
            // ),
          ],
        ),
      )),
    );
  }
}
