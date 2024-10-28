import 'package:json_annotation/json_annotation.dart';
part 'task.g.dart';

@JsonSerializable()
class Task {
  String title;
  String? description;
  bool completed;
  DateTime? deadLine;

  // Simple constructor.
  Task({required this.title, String? descrip, this.completed = false}) : description = (descrip == '')? null : descrip;
  // Constructor that includes deadLine.

   Task.withDeadLine(
    {required this.title,
    String? descrip,
    this.deadLine,
    this.completed = false}) : description = (descrip == '') ? null : descrip;

  
  // CLASS METHODS:
  void toogleCompleted(){
    completed = !completed;
  }
  bool isCompleted(){
    return completed;
  }

  String? getDateWithFormat() {
    int lastString = 10;
    if (deadLine != null){
      String? deadLineFormated = deadLine!.toIso8601String().substring(0, lastString);
      return deadLineFormated;
    }
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      "title" : title,
      "description" : description,
      "deadLine" : getDateWithFormat(),
      "completed" : completed
    };
  }
  // SERIALIZATION AND DESERIALIZATION
  // factory constructor to get Task FromJson 
  factory Task.fromJson(Map<String, dynamic> json) {
    var task = _$TaskFromJson(json);
    return task;
  } 
  // factory constructor to get Json from Task
  Map<String, dynamic> toJson() {
    var json = _$TaskToJson(this);
    return json;
  } 

  
}
