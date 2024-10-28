
import 'package:postgres/postgres.dart';

class DbManager {
  late Connection _connection;

  // Private constructor to avoid the creation of the object with empty connection.
  DbManager._privateConstructor();

  // Static constructor to let us create the object and later asign the connection
  static Future<DbManager> connectionOpen() async {
    var dbManager = DbManager._privateConstructor();
    await dbManager.createConnection();
    return dbManager;
  }


  // OPEN CONNECTION
  Future<void> createConnection() async {
    
    _connection = await Connection.open(Endpoint(
            host: 'localhost',
            database: 'PRUEBAS',
            username: 'postgres',
            password: 'deisapostgres',
        ),
        settings: ConnectionSettings(sslMode: SslMode.disable)
      );
    
    /*
    connection = await Connection.open(Endpoint(
            host: 'localhost',
            database: 'Tasks',
            username: 'postgres',
            password: 'postgres',
        ),
        settings: ConnectionSettings(sslMode: SslMode.disable)
      );
    */
    print('Connected to the database');
    }

  // CLOSE CONNECTION AND RETURN IF CLOSED.
  Future<bool> closeConnection() async {
    await _connection.close();
    return _connection.isOpen;
  }

  // CREATION OF TABLE TASKS_TAS IF NOT EXISTS.
  Future<void> createTaskTableIfNotExists() async{
    await _connection.execute("""CREATE TABLE IF NOT EXISTS "TASKS_TAS"(
                                          id 			        SERIAL NOT NULL,
                                          title 			    VARCHAR(70) NOT NULL,
                                          description 		VARCHAR(500),
                                          completed 		  BOOLEAN DEFAULT FALSE,
                                          deadline 		    TIMESTAMP,
                                          CONSTRAINT TASK_PRIMARY_KEY PRIMARY KEY(id)
                                          )""");
  }

  // RETURNS EVERYTASK.
  Future<List> getEveryTask() async{
    final result = await _connection.execute('SELECT * FROM "TASKS_TAS"');
    return result;
  }

  Future<List> getBetweenDates(String date1, String date2){
    // THIS STRUCTURE PROTECTS YOU FROM SQLinjection!!!!!!!
    final result = _connection.execute(r'SELECT * FROM "TASKS_TAS" WHERE deadline BETWEEN $1 and $2',
                                      parameters: [date1, date2]);
    return result;
  }

  // Makes a complex query "where = params". It's a safe query from SQLINJECTION.
  Future<List> getTaskWithQuery([String? title, String? description, String? date, bool? completed]) async{
    // We set an editable query.
    // A counter to write the params accordly.
    // A List of params to use at the end.
    Map<String, dynamic> queryStructure;
    queryStructure = getPersonalizedQuery(title, description, date, completed);

      if (queryStructure["query"] != '') {
        queryStructure["query"] = 'WHERE ${queryStructure["query"]}';
      }
      //print(r'SELECT * FROM task' + query);
      final result = await _connection.execute(r'SELECT * FROM "TASKS_TAS" ' + queryStructure["query"], 
                                        parameters: queryStructure["params"]);
      return result;
  }

  Future<List> getTaskByID(int id) async {
    final result = await _connection.execute(r'SELECT * FROM "TASKS_TAS" WHERE id=$1',
                                            parameters: [id]);
    return result;
  }

  Future<bool> deleteTaskByID(int id) async {
    bool wasDeleted = false;
    await _connection.execute(r'DELETE FROM "TASKS_TAS" WHERE id=$1',
                            parameters: [id]);
    await getTaskByID(id).then((task) {
      if (task.isEmpty) {
        wasDeleted = true;
      }
    });
    return wasDeleted;
  }

  Future<bool> updateTaskByID(int id, [String? title, String? description, String? date, bool? completed]) async {
    bool wasUpdated;
    Map<String, dynamic> queryStructure;

    queryStructure= getPersonalizedQuery(title, description, date, completed);

    if (queryStructure["query"] != '') {
      queryStructure["query"] = 'SET${queryStructure["query"]} WHERE id = \$${queryStructure["counter"]}';
      queryStructure["params"].add(id);
    }
    else {
      wasUpdated = false;
      return wasUpdated;
    }
    try {
      print(r'UPDATE "TASKS_TAS" ' + queryStructure["query"]);
      await _connection.execute('UPDATE "TASKS_TAS" ${queryStructure["query"]} ', 
                                parameters: queryStructure["params"]);
      wasUpdated = true;
    }
    catch(e){
      wasUpdated = false;
    }
    return wasUpdated;
  }

// Testing a new method. Giving the object as a Map.
// NOTE: I don't like it
Future<bool> insertTask(Map<String, dynamic> task) async{
  bool wasInserted = false;
  String columns = '';
  String values = '';

  task.forEach((key, value) {
    columns += '$key, ';
    (value == null)?
      values += "$value, " :
      values += "'$value', ";
  });
  
  // Remove the last ', ';
  columns = columns.substring(0, columns.length - 2);
  values = values.substring(0, values.length - 2);

  String query = 'INSERT INTO "TASKS_TAS" ($columns) VALUES ($values)';
  print(query);
  try {
    await _connection.execute(query);
    wasInserted = true;
    return wasInserted;
  }
  catch (e) {
    return wasInserted;
  }
  
}

Future<bool> dropTable() async{
  bool wasDropt = false;
  try{
    await _connection.execute('DROP TABLE IF EXISTS "TASKS_TAS"');
    wasDropt = true;
  } catch(e) {
    return wasDropt;
  }
  return wasDropt;
}

// GET PERSONALIZED QUERY WITH INPUTS.
Map<String, dynamic> getPersonalizedQuery([String? title, String? description, String? date, bool? completed]){
      String query = '';
      int counter = 1;
      List params = [];

      if (title != null && title != '') {
        query = r' title = $' + counter.toString();
        params.add(title);
        counter++;
      }
      if (description != null && description != '') {
        (query == '')?
          query += r' description = $' + counter.toString() :
          query += r' , description = $' + counter.toString();
        params.add(description);
        counter++;
      }
      if (date != null && date != '') {
        (query == '')?
          query += r' deadline = $' + counter.toString() :
          query += r' , deadline = $' + counter.toString();
        params.add(date);
        counter++;
      }
      if (completed != null) {
        (query == '')?
          query += r' completed = $' + counter.toString() :
          query += r' , completed = $' + counter.toString();
        params.add(completed);
        counter++;
      }
      return ({"counter": counter,
               "query": query,
               "params": params});
}
}