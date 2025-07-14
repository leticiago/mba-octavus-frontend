class Activity {
  final String? id;
  final String name;
  final String description;
  final int type;
  final DateTime date;
  final int level;
  final bool isPublic;
  final String instrumentId;
  final String? professorId;

  Activity({
    this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.date,
    required this.level,
    required this.isPublic,
    required this.instrumentId,
    this.professorId,
  });

 factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      date: DateTime.parse(json['date']),
      level: json['level'],
      isPublic: json['isPublic'],
      instrumentId: json['instrumentId'],
      professorId: json['professorId'],
    );
  }
  
  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'type': type,
        'date': date.toIso8601String(),
        'level': level,
        'isPublic': isPublic,
        'instrumentId': instrumentId,
        'professorId': professorId,
      };
}
