class QuestionModel {
  List<QuestionResult>? results;

  QuestionModel({this.results});

  QuestionModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <QuestionResult>[];
      json['results'].forEach((v) {
        results!.add(QuestionResult.fromJson(v));
      });
    }
  }
}

class QuestionResult {
  String? objectId;
  String? lessonName;
  ImageQuestion? imageQuestion;
  String? correctAnswer;
  String answer = 'هیچکدام';
  DateTime? createdAt;
  DateTime? updatedAt;

  QuestionResult({
    this.objectId,
    this.lessonName,
    this.imageQuestion,
    this.correctAnswer,
    required this.answer,
    this.createdAt,
    this.updatedAt,
  });

  QuestionResult.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    lessonName = json['lessonName'];
    imageQuestion = json['imageQuestion'] != null
        ? ImageQuestion.fromJson(json['imageQuestion'])
        : null;
    correctAnswer = json['correctAnswer'];
    createdAt = DateTime.parse(json['createdAt']);
    updatedAt = DateTime.parse(json['updatedAt']);
  }
}

class ImageQuestion {
  String? type;
  String? name;
  String? url;

  ImageQuestion({this.type, this.name, this.url});

  ImageQuestion.fromJson(Map<String, dynamic> json) {
    type = json['__type'];
    name = json['name'];
    url = json['url'];
  }
}
