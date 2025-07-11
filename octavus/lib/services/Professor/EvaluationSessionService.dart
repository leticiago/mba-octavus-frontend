class EvaluationSessionService {
  static String? studentId;
  static String? activityId;

  static void setEvaluation(String sid, String aid) {
    studentId = sid;
    activityId = aid;
     print('[EvaluationSessionService] Setado studentId=$sid, activityId=$aid');
  }

  static void clear() {
    studentId = null;
    activityId = null;
  }
}
