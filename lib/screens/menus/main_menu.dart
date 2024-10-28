import 'menu.dart';
import 'dart:io';

class MainMenu extends Menu {

  MainMenu({required super.taskManager});
  
  DateTime? createDeathLine(){
  String? year, month, day;
  print("Add a year");
  year = stdin.readLineSync();
  print("Add a month");
  month = stdin.readLineSync();
  print("Add a day");
  day = stdin.readLineSync();
  if (year != null && month != null && day != null){
    return DateTime(int.parse(year), int.parse(month), int.parse(day));
    }
  return null;
  }

  void createTask(){
  // This function will be the one that ask the user how to create a task.
  print("Add the title for the new task");
  String? title = stdin.readLineSync();

  if (title != null && title != ''){
    print("Add a description for the new task");
    String? description = stdin.readLineSync();

    // print("Type Y if you want to add a deathline.");
    if (getYesNo("Do you want to add a deathline? Y/N")) {
      taskManager.addTask(title, description, createDeathLine());
      return;
    }
    taskManager.addTask(title, description);
  }
  else {
    print("The title can't be null");
    }
  }

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
1 to add a task.
2 to see everytask
3 to see one task
4 to complete a task
5 to uncomplete a task
6 to interact with JSON
7 to interact with the DataBase
8 Close the program.
--------------------------------------""");

  String? option = stdin.readLineSync();
  clearConsole();
  switch(option){
    case "1":
      createTask();
    case "2":
      print(taskManager.showEveryTask());
    case "3":
      showOneTask();
    case "4":
      completeTask();
    case "5":
      unCompleteTask();
    case "6":
      // Returns selection to activate the JSON menu.
      menuSelection = 1;
    case "7":
      // Returns selection to activate the DB menu.
      menuSelection = 2;
    case "8":
      // Returns selection to close the app.
      print("Bye Bye!");
      menuSelection = 3;
    }
    return menuSelection;
  }

  // MENU METHODS
  void showOneTask(){
    print("What task do you want to see?");
    String? taskNumberString = stdin.readLineSync();
    int? taskNumber = int.tryParse(taskNumberString?? '');

    if (taskNumber != null) {
      print(taskManager.showTask(taskNumber));
    }
    else {
      print("The number selected can't be null");
    }
  }

  void completeTask(){
    print("What task do you want to COMPLETE?");
    String? taskNumberString = stdin.readLineSync();
    int? taskNumber = int.tryParse(taskNumberString?? '');
    int result = taskManager.completeTask(taskNumber?? -2);

    switch(result) {
      case 0:
        print("The task was completed!");
      case -1:
        print("The task has already been completed.");
      default:
        print("The number you gave was out of range.");
    }
  }

  void unCompleteTask(){
    print("What task do you want to UNCOMPLETE?");
      String? taskNumberString = stdin.readLineSync();
      int? taskNumber = int.tryParse(taskNumberString?? '');
      int result = taskManager.unCompleteTaks(taskNumber?? -2);
      switch(result) {
        case 0:
          print("The task was uncompleted!");
        case -1:
          print("The task hasn't been completed yet.");
        default:
          print("The number you gave was out of range.");
      }
  }
}