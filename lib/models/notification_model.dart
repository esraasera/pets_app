class NotificationModel {
  String? id;
  String? title;
  String? body;
  String? date;

  NotificationModel({
    this.id,
    this.title,
    this.body,
    this.date,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return NotificationModel(
      id: id,
      title: json['title'],
      body: json['body'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'date': date,
    };
  }
}