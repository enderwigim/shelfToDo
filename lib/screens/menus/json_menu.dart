import 'menu.dart';
import 'dart:io';
import '../../../services/task_manager.dart';
import 'dart:convert';

class JsonMenu extends Menu {

  JsonMenu({required super.taskManager});

  @override
  int displayMenu(int menuNum){
    // We will set an integer that returns what the ToDoList use to
    // know what menu display
    // 0 - Always goes back to the main menu.
    // 1 - Goes to Json Menu
    // 2 - Goes to DB Menu
    // 3 - Close the app
    int menuSelection = menuNum;
    print("""
--------------------------------------
1 to show task as a JSON
2 to create a JSON file with every task
3 to import a JSON file with tasks
4 BACK
--------------------------------------
""");
    String? option = stdin.readLineSync();
    clearConsole();
      switch(option){
        case "1":
          getTaskAsJson();
        case "2":
          createFileWithEveryTask(taskManager);
        case "3":
          importTasksFromJson();
        case "4":
          menuSelection = 0;
        }
      return menuSelection;
  }

  // Create file method.
  void createFileWithEveryTask(TaskManager taskManager) {
    String filePath = './lib/assets/json/exportedTasks.json'; 
    String jsonString = jsonEncode(taskManager.getJsonOfEveryTask());

    File(filePath).writeAsStringSync(jsonString);
    print(".json was created in $filePath");
  }

  // Menu methods
  void getTaskAsJson() {
    print("What task do you want to get as Json?");
    String? taskNumberString = stdin.readLineSync();
    int? taskNumber = int.tryParse(taskNumberString?? '');
    Map<String, dynamic> json = taskManager.getJsonFromTask(taskNumber?? -1);
    print(jsonEncode(json));
  }

  void importTasksFromJson() {
    print("Introduce the name of the file: Ex: tasks.json. It must be inside ./assets/json/");
    // Need to change later
    String filePath = "./assets/json/${stdin.readLineSync()?? 'task.json'}";
    try {
      String jsonString = File(filePath).readAsStringSync();
      var json = jsonDecode(jsonString);
      for (Map<String, dynamic>task in json){
        taskManager.addFromJson(task);
      }
      print("Tasks imported from: $filePath");
    }
    catch (e){
      print("An error was raised.");
      print(e);
    }
  }
}
