import 'package:flutter/material.dart';

class QuestionFormData {
  final TextEditingController titleController = TextEditingController();
  final List<AnswerFormData> answers = List.generate(3, (_) => AnswerFormData());
}

class AnswerFormData {
  final TextEditingController textController = TextEditingController();
  bool isCorrect = false;
}
