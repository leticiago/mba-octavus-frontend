class AssignActivityRequest {
  final String studentId;
  final String activityId;

  AssignActivityRequest({required this.studentId, required this.activityId});

  Map<String, dynamic> toJson() => {
        'studentId': studentId,
        'activityId': activityId,
      };
}
