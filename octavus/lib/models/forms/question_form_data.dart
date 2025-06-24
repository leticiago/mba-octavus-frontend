import 'answer_form_data.dart';
import 'package:flutter/material.dart';

class QuestionFormData {
  final TextEditingController titleController = TextEditingController();
  List<AnswerFormData> answers;
  int correctAnswerIndex;

  QuestionFormData({
    String questionTitle = '',
    List<AnswerFormData>? answers,
    this.correctAnswerIndex = 0,
  }) : answers = answers ?? [AnswerFormData(), AnswerFormData(), AnswerFormData()] {
    titleController.text = questionTitle;
  }
}
