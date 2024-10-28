import '../../../services/task_manager.dart';
import 'dart:io';

abstract class Menu {
  
  final TaskManager taskManager;

  
  Menu({required this.taskManager});
  
  int displayMenu(int menuNum);

  void clearConsole() {
  // Use 'cls' command to clear the console
  print("\x1B[2J\x1B[0;0H");
  }

  bool getYesNo(String message){
    print(message);
    String yesNoString = stdin.readLineSync()!.toUpperCase();
    if (yesNoString != "Y" && yesNoString != "N") {
      getYesNo(message);
    }
    return (yesNoString == "Y")? true : false;
  }
}