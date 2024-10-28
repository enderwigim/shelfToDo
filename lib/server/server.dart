import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:dart1/models/task.dart';


// SET ROUTES THAT SERVER WILL HANDLE
  final router = Router()
    // HOME ROUTES
    ..get('/', (Request request) async {
    final file = File('web/html/index.html');
    if (await file.exists()) {
      final htmlContent = await file.readAsString();

      Task task = Task.withDeadLine(title: "Codear", descrip: "Necesito codigin", deadLine: DateTime.now(), completed: false);
      String modifiedHtml = htmlContent
                  .replaceAll('{{title}}', task.title)
                  .replaceAll('{{descrip}}', task.description?? 'No hay description')
                  .replaceAll('{{deadLine}}', task.deadLine!.toString())
                  .replaceAll('{{completed}}', task.completed? 'Completo' : 'Incompleto');

      print(task.title);
      print(task.description);
      print(task.deadLine);
      print(task.completed);
      return Response.ok(
        modifiedHtml,
        headers: {'content-type': 'text/html'},
      );
    } else {
      // FILE DOESN'T EXISTS. RETURN 404
      return Response.notFound('404 - File Not Found');
    }
  });


void main() async {
    
  final handler = Pipeline().addHandler(router);

  // Start the server and listen for requests
  final server = await shelf_io.serve(handler, 'localhost', 8080);
  print('Hi Santiago, Server listening on port ${server.port}');
}