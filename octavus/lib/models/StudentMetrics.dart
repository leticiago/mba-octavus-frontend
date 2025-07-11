class StudentMetrics {
  final int totalActivitiesDone;
  final double averageScore;
  final Map<String, double> averageScoreByActivityType;

  StudentMetrics({
    required this.totalActivitiesDone,
    required this.averageScore,
    required this.averageScoreByActivityType,
  });

  factory StudentMetrics.fromJson(Map<String, dynamic> json) {
    final Map<String, double> typeScores = {};
    (json['averageScoreByActivityType'] as Map<String, dynamic>).forEach((key, value) {
      typeScores[key] = (value as num).toDouble();
    });

    return StudentMetrics(
      totalActivitiesDone: json['totalActivitiesDone'],
      averageScore: (json['averageScore'] as num).toDouble(),
      averageScoreByActivityType: typeScores,
    );
  }
}
