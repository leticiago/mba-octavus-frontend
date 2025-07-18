class StudentCompletedActivity {
  final String activityId;
  final String title;
  final String type;
  final int? score;
  final DateTime correctionDate;

  StudentCompletedActivity({
    required this.activityId,
    required this.title,
    required this.type,
    this.score,
    required this.correctionDate,
  });

  factory StudentCompletedActivity.fromJson(Map<String, dynamic> json) {
    return StudentCompletedActivity(
      activityId: json['activityId'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      score: json['score'] != null ? (json['score'] as int) : null,
      correctionDate: DateTime.parse(json['correctionDate'] as String),
    );
  }
}
 