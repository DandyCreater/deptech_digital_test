class AgendaEntity {
  final String? id;
  final String? date;
  final String? description;
  final String? picture;
  final String? remindVal;
  final bool? reminder;
  final String? time;
  final String? title;

  const AgendaEntity(
      {required this.id,
      required this.date,
      required this.description,
      required this.picture,
      required this.remindVal,
      required this.reminder,
      required this.time,
      required this.title});

  factory AgendaEntity.fromJson(Map<String, dynamic> json) {
    return AgendaEntity(
        id: json['id'],
        date: json['date'],
        description: json['description'],
        picture: json['picture'],
        remindVal: json['remindVal'],
        reminder: json['reminder'],
        time: json['time'],
        title: json['title']);
  }
}