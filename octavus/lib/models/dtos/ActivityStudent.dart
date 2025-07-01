enum ActivityStatus {
  pending,
  inProgress,
  completed,
}

ActivityStatus activityStatusFromString(dynamic status) {
  if (status is int) {
    switch (status) {
      case 0:
        return ActivityStatus.pending;
      case 1:
        return ActivityStatus.inProgress;
      case 2:
        return ActivityStatus.completed;
      default:
        throw Exception('Status numérico desconhecido: $status');
    }
  } else if (status is String) {
    switch (status.toLowerCase()) {
      case 'pending':
        return ActivityStatus.pending;
      case 'inprogress':
      case 'in_progress':
        return ActivityStatus.inProgress;
      case 'completed':
        return ActivityStatus.completed;
      default:
        throw Exception('Status textual desconhecido: $status');
    }
  } else {
    throw Exception('Formato de status inválido: $status');
  }
}

class ActivityStudent {
  final String activityId;
  final String title;
  final String description;
  final ActivityStatus status;
  final int? score;
  final String comment;
  final bool isCorrected;
  final DateTime? correctionDate;

  ActivityStudent({
    required this.activityId,
    required this.title,
    required this.description,
    required this.status,
    this.score,
    required this.comment,
    required this.isCorrected,
    this.correctionDate,
  });

  factory ActivityStudent.fromJson(Map<String, dynamic> json) {
    return ActivityStudent(
      activityId: json['activityId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: activityStatusFromString(json['status']),
      score: json['score'],
      comment: json['comment'] ?? '',
      isCorrected: json['isCorrected'] as bool,
      correctionDate: json['correctionDate'] != null
          ? DateTime.parse(json['correctionDate'])
          : null,
    );
  }
}
