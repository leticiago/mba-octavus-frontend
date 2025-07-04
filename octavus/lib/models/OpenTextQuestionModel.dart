class OpenTextQuestionModel {
  final String id;
  final String title;
  final List<dynamic> answers;

  OpenTextQuestionModel({
    required this.id,
    required this.title,
    required this.answers,
  });

  factory OpenTextQuestionModel.fromJson(Map<String, dynamic> json) {
    return OpenTextQuestionModel(
      id: json['id'],
      title: json['title'],
      answers: json['answers'] ?? [],
    );
  }
}
