import 'menus/json_menu.dart';
import 'menus/main_menu.dart';
import 'menus/db_menu.dart';
import '../../services/task_manager.dart';
import '../../services/data_base_management.dart';

class Todolist{
  // This class will interact with other classes and with the user.
  // With this, we avoid to fill our main() full lots of code.
  bool isRunning = true;
  int menuNumber = 0;
  final TaskManager taskManager = TaskManager();
  // dbManager will be set and connected later.
  late DbManager dbManager;


  late JsonMenu jsonMenu;
  late DbMenu dbMenu;
  late MainMenu mainMenu;

  
  void run() async{
    dbMenu = DbMenu(taskManager: taskManager);
    await dbMenu.askToImportDataBeforeLaunch();

    print("""---------------ToDoList---------------""");

    while(isRunning){
      if (menuNumber == 0){
         mainMenu = MainMenu(taskManager: taskManager);
         menuNumber = mainMenu.displayMenu(menuNumber);
      }
      else if (menuNumber == 1){
         jsonMenu = JsonMenu(taskManager: taskManager);
         menuNumber = jsonMenu.displayMenu(menuNumber);
      }
      else if (menuNumber == 2){
        // dbMenu executes with async/await. To run it and
        // specify to wait until it finished before continue
        // we must turn runDbMenu in a Future function.
        dbMenu = DbMenu(taskManager: taskManager);
        menuNumber = await dbMenu.displayMenuAsync(menuNumber);
      }
      else if (menuNumber == 3){
        isRunning = false;
      }
    }
  }
  
}