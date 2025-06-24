import 'package:flutter/material.dart';

class AnswerFormData {
  final TextEditingController textController = TextEditingController();
  bool isCorrect;

  AnswerFormData({String text = '', this.isCorrect = false}) {
    textController.text = text;
  }
}
