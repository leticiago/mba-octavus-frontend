class Activity {
  final String name;
  final String description;
  final int type;
  final DateTime date;
  final int level;
  final bool isPublic;
  final String instrumentId;
  final String professorId;

  Activity({
    required this.name,
    required this.description,
    required this.type,
    required this.date,
    required this.level,
    required this.isPublic,
    required this.instrumentId,
    required this.professorId,
  });

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
