import 'package:hive/hive.dart';

part 'quiz_model.g.dart';

@HiveType(typeId: 0)
class QuizModel {
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? date;
  @HiveField(2)
  List? quizLessons;
  @HiveField(3)
  List? quizPercentages;
  @HiveField(4)
  String? time;
  @HiveField(5)
  String? type;

  QuizModel({
    required this.title,
    required this.date,
    required this.quizPercentages,
    required this.quizLessons,
  });
}
