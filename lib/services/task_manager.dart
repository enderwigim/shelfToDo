import '../../models/task.dart';

class TaskManager{
  final List<Task> taskList = [];
  
  void addTask(String title, String? description, [DateTime? deadLine, bool? completed]){
    /* Dart allows you to simplify if-else with this tipe of expressions.
    (deadLine == null)? --> Condition
    taskList.add(Task(title, description)) --> if condition = true.
    taskList.add(Task.withDeadLine(title, description, deadLine)) --> if condition = false.
      */
    (deadLine == null)? 
        taskList.add(Task(title: title, 
                          descrip: (description != '')? description : null,
                          completed : completed?? false)) : 
        taskList.add(Task.withDeadLine(title: title, 
                                        descrip: (description != '')? description : null,
                                        deadLine : deadLine,
                                        completed: completed?? false));
  }
  void addFromJson(Map<String, dynamic> task){
    // Create a task from JSON.
    taskList.add(Task.fromJson(task));
  }
  
  String showEveryTask(){
    // Will return every single task. If there's no tasks in the list. It will return an empty String.
    String everyTaskTitle = """
--------------------------------------
${taskList.length} TASKS IN TOTAL:
--------------------------------------
""";
    for (int i = 0; i < taskList.length; i++){
      if (!taskList[i].isCompleted()){
        everyTaskTitle += "${(i + 1)} ${taskList[i].title}\n";
      }
      else {
        everyTaskTitle += "${(i + 1)} ${taskList[i].title} ☑️\n";
      }
    }
    return everyTaskTitle.substring(0, everyTaskTitle.length - 1);
  }

  String showTask(int taskNumber){
    // return task selected if exists.
    int index = taskNumber - 1;
      if ((index) < taskList.length && (index) >= 0){
          return ("Tarea Nº$taskNumber \n ${taskList[index].title} \n ${taskList[index].description} \n ${taskList[index].getDateWithFormat()?? "No deadline."}");
        }
    return "That task doesn't exists.";
  }
  int completeTask(int taskNumber){
    /*
    Marks task as completed
    RESULTS:
    0 --> Done without problems.
    -1 --> The task exists but it has already been completed.
    -2 --> The taskNumber was out of range.
    */
    int index = taskNumber - 1;
    if ((index) < taskList.length && (index) >= 0){
      if(!taskList[index].isCompleted()){
          taskList[index].toogleCompleted();
          return 0;
      }
      return -1;
    }
    return -2;
  }
  int unCompleteTaks(int taskNumber){
    /*
    Mark task as uncompleted
    RESULTS:
    0 --> Done without problems.
    -1 --> The task exists but it was marked as completed before.
    -2 --> The taskNumber was out of range.
    */
    int index = taskNumber - 1;
    if ((index) < taskList.length && (index) >= 0){
      if(taskList[index].isCompleted()){
          taskList[index].toogleCompleted();
          return 0;
      }
      return -1;
    }
    return -2;
  }
  Map<String, dynamic> getJsonFromTask(int taskNumber) {
    int index = taskNumber - 1;
    if ((index) < taskList.length && (index) >= 0){
      return taskList[index].toJson();
    }
    return <String, dynamic>{
            'code' : 404,
            'error' : 'Task not founded.'
            };
  }
  List<Map<String, dynamic>> getJsonOfEveryTask() {
    List<Map<String, dynamic>> json = [];
    for (int i = 0; i < taskList.length; i++) {
      // As getJsonFromTask transforms parameter into index by -1. We will
      // call that function adding 1 to i.
      json.add(getJsonFromTask(i + 1));
    }
    if (json.isNotEmpty){
      return json;
    }
    return [{
            'code' : 404,
            'error' : 'Task not founded.'
            }];
  }
  
}
