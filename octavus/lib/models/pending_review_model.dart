class PendingReview {
  final String activity;
  final String activityId;
  final String student;
  final String studentId;
  

  PendingReview({
    required this.activity,
    required this.student,
    required this.activityId,
    required this.studentId,
  });

  factory PendingReview.fromJson(Map<String, dynamic> json) {
    return PendingReview(
      activity: json['activityName'] ?? '',
      student: json['studentName'] ?? '',
      studentId: json['studentId'] ?? '',
      activityId: json['activityId'] ?? '', 
    );
  }
}
