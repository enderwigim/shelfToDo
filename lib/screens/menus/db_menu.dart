import 'menu.dart';
import 'dart:io';
import '../../../services/data_base_management.dart';

class DbMenu extends Menu{

  late DbManager dbManager;
  
  DbMenu({required super.taskManager});

  // TODO: Solve this approach
  // I don't really like it. But I don't know what's the best thing to do.
  // FIRST OPTION: Leave it like this :')
  // SECOND OPTION: Turn this class into a separated one from menu,
  // import other funtions as if it were from this class.
  // THIRD OPTION: ?? Help please
  @override
  int displayMenu(int menuNum){
    return -1;
  }

  // This function will ask you if you want to importEveryTask in the DB before starting.
  Future<void> askToImportDataBeforeLaunch() async{
    if (getYesNo("Do you want to import every task in DB before Launching? Y/N")){
      dbManager = await DbManager.connectionOpen();
      await importEveryTaskInDB();
      await dbManager.closeConnection();
    }
  }

  Future<int> displayMenuAsync(int menuNum) async{
    // We will set an integer that returns what the ToDoList use to
    // know what menu display
    // 0 - Always goes back to the main menu.
    // 1 - Goes to Json Menu
    // 2 - Goes to DB Menu
    // 3 - Close the app
    int menuSelection = menuNum;
    print("""
--------------------------------------
1 Create DataBase if not exists
2 Import every task in the DataBase
3 Import tasks querying between Dates
4 Get tasks by query
5 Get task by ID
6 Delete task by ID
7 Update task
8 Insert Task into DB
9 Drop Table
10 BACK
--------------------------------------
""");
    String? option = stdin.readLineSync();
    clearConsole();
    dbManager = await DbManager.connectionOpen();
      switch(option){
        case "1":
          await createDBIfNotExists(); 
        case "2":
          await importEveryTaskInDB();    
        case "3":
          await importTaskQueryingBetweenDates();    
        case "4":
          await getTasksByQuery();
        case "5":
          await fetchDataById();
        case "6":
          await delteID();
        case "7":
          await updateTask();
        case "8" : 
          await insertTask();
        case "9" :
          await dropTable();
      case "10":
        menuSelection = 0;
        }
      await dbManager.closeConnection().then((isClosed) {
          !isClosed? print("The connection was closed.") : print("Error: The connection was not closed");
        });
      return menuSelection;   
  }
  Future<void> dropTable() async {
      if(getYesNo("Are you sure you want to DROP the table. All will be lost. Y/N")){
        if(await dbManager.dropTable()){
          print("DELETED!");
        } else {
          print("An error occured: The database is link to another table");
        }
      }
  }
  Future<void> createDBIfNotExists() async{
     try {
        await dbManager.createTaskTableIfNotExists();
        print("Table TASKS_TAS created or already exist in the DB.");
      }
      catch(e) {
        print("An error raised during creation of table \n $e");
      }
  }
  Future<void> importEveryTaskInDB() async{
    try {
      await dbManager.getEveryTask().then((everyTask) {
        for (List task in everyTask) {
          // task structure:
          // [0] = id;
          // [1] = title;
          // [2] = description;
          // [3] = completed;
          // [4] = deadline;
          taskManager.addTask(task[1], task[2], task[4], task[3]);
        }
      });
    } catch (e) {
      print("There was an error getting the tasks: \n $e");
    }  
  }
  Future<void> importTaskQueryingBetweenDates() async{
    print("Add the first date:");
    String? date1 = stdin.readLineSync();
    print("Add the second date:");
    String? date2 = stdin.readLineSync();
    try {
      await dbManager.getBetweenDates(date1!, date2!).then((everyTask) {
      // await dbManager.getEveryTask().then((everyTask) {
        for (List task in everyTask) {
          // task structure:
          // [0] = id;
          // [1] = title;
          // [2] = description;
          // [3] = completed;
          // [4] = deadline;
          taskManager.addTask(task[1], task[2], task[4], task[3]);
        }
      });
    } catch (e) {
      print("There was an error getting the tasks: \n $e");
    }
  }
  Future<void> getTasksByQuery() async{
    print("Now you are going to select params. \n ALERT: If you SKIP everything it will return every TASK in the DB");
    print("Add the title: Leave empty to SKIP");
    String? title = stdin.readLineSync();

    print("Add a description: Leave empty to SKIP");
    String? description = stdin.readLineSync();

    print("Add a deadline: #2024-05-30 FORMAT Leave empty to SKIP");
    String? deadLine = stdin.readLineSync();

    print("Was it completed? Y/N \nLeave empty to SKIP");
    String? wasCompleted = stdin.readLineSync()!;
    bool? wasCompletedBool;
    if (wasCompleted.toLowerCase() == 'y' || wasCompleted.toLowerCase() == 'n') {
      (wasCompleted.toLowerCase() == 'y')? wasCompletedBool = true : wasCompletedBool = false;
    }
    else {
      print("The only option is Y/N");
    }
    
    await dbManager.getTaskWithQuery(title, description, deadLine, wasCompletedBool).then((everyTask) {
      if (everyTask.isNotEmpty) {
        print("Tasks fetched: ${everyTask.length} \n");
        bool addToToDoList = getYesNo("Do you want to add them to the ToDoList? Y/N");
        if (addToToDoList) {
            for (List task in everyTask) {
              taskManager.addTask(task[1], task[2], task[4], task[3]);
            }
        } 
        else {
          for (List task in everyTask) {
            print(task);
          }
        }
      } else {
        print("No tasks were founded");
      }
    });
  }
  Future<void> fetchDataById() async{
    print("What ID you want to fetch?");
    String? idString = stdin.readLineSync();
    int? id = int.tryParse(idString?? '');
    (id != null)? {
      await dbManager.getTaskByID(id).then((task) {
        if (task != []) {
          print(task);
        } else {
          print("No task was founded");
        }
      })
    } :
    print("That was not an ID available.");
  }
  Future<void> delteID() async {
     print("What ID you want to delete?");
          String? idString = stdin.readLineSync();
          int? id = int.tryParse(idString?? '');

          (id != null)? {
            await dbManager.getTaskByID(id).then((task) async {
              if (task != [] ) {
                print(task);
                if(getYesNo("Are you sure you want to DELETE it? Y/N")) {
                  await dbManager.deleteTaskByID(id).then((wasDeleted) {
                    if (wasDeleted) {
                      print("The task with ID = $id was deleted");
                    }
                  });
                }
              } else {
                print("No task was founded");
              }
            })
          } :
          print("That was not an ID available.");
  }
  Future<void> insertTask() async {
    int? taskToInsert;
    print(taskManager.showEveryTask());
    print("What task do you want to delete?");
    taskToInsert = int.tryParse(stdin.readLineSync()?? '');
    if (taskToInsert != null) {
      bool wasDataInserted = await dbManager.insertTask(taskManager.taskList[taskToInsert - 1].toMap());
      (wasDataInserted)? print("Data was inserted") : print("Error, data was not inserted");
    }
    else {
      print("Task isn't valid");
    }
  }
  
  Future<void> updateTask() async{
    print("What ID you want to UPDATE?");

    String? idString = stdin.readLineSync();
    int? id = int.tryParse(idString?? '');

    (id != null)? {
      await dbManager.getTaskByID(id).then((task) async {
        if (task != [] ) {
          print(task);
          if(getYesNo("Are you sure you want to UPDATE it? Y/N")) {
            print("Now you are going to select params. \n ALERT: If you SKIP everything it will return every TASK in the DB");
            print("Add the title: Leave empty to SKIP");
            String? title = stdin.readLineSync();

            print("Add a description: Leave empty to SKIP");
            String? description = stdin.readLineSync();

            print("Add a deadline: #2024-05-30 FORMAT Leave empty to SKIP");
            String? deadLine = stdin.readLineSync();

            print("Was it completed? Y/N \nLeave empty to SKIP");
            String? wasCompleted = stdin.readLineSync()!;
            bool? wasCompletedBool;
            if (wasCompleted.toLowerCase() == 'y' || wasCompleted.toLowerCase() == 'n') {
              (wasCompleted.toLowerCase() == 'y')? wasCompletedBool = true : wasCompletedBool = false;
            }
            else {
              print("The only option is Y/N");
            }
            await dbManager.updateTaskByID(id, title, description, deadLine, wasCompletedBool)
              .then((wasUpdated) {
                wasUpdated?
                  print("Task updated") :
                  print("Something wrong happen. The task wasn't updated");
              });
          }
        } 
        else {
          print("No task was founded");
        }
      })
    } :
    print("That was not an ID available.");
  }
}

