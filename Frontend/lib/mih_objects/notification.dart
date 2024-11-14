class MIHNotification {
  final int idnotifications;
  final String app_id;
  final String notification_message;
  final String notification_read;
  final String action_path;
  final String insert_date;
  final String notification_type;

  const MIHNotification({
    required this.idnotifications,
    required this.app_id,
    required this.notification_message,
    required this.notification_read,
    required this.action_path,
    required this.insert_date,
    required this.notification_type,
  });

  factory MIHNotification.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "idnotifications": int idnotifications,
        "app_id": String app_id,
        "notification_message": String notification_message,
        "notification_read": String notification_read,
        "action_path": String action_path,
        "insert_date": String insert_date,
        "notification_type": String notification_type,
      } =>
        MIHNotification(
          idnotifications: idnotifications,
          app_id: app_id,
          notification_message: notification_message,
          notification_read: notification_read,
          action_path: action_path,
          insert_date: insert_date,
          notification_type: notification_type,
        ),
      _ => throw const FormatException('Failed to load Notifications.'),
    };
  }
}
