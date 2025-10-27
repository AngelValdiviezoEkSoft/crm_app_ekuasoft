class NotificationModel {
  final int id;
  final String title;
  final String message;
  final DateTime date;
  final String icon;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.icon,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      date: DateTime.parse(json['date']),
      icon: json['icon'] ?? 'notifications',
    );
  }
}
