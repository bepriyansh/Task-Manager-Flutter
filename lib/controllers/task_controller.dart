import 'package:get/get.dart';
import 'package:taskmanager/database/db_helper.dart';
import 'package:taskmanager/models/task.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  var taskList = <TaskToDo>[].obs;

  Future<int> addTask({TaskToDo? task}) async {
    print("Adding task to Db");
    return await DBHelper.insert(task);
  }

  void getTasks() async {
    print("Getting tasks from DB .......");
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => TaskToDo.fromJson(data)).toList());
  }

  void delete(TaskToDo task) async {
    DBHelper.delete(task);
  }

  void markTaskCompleted(int id) async {
    await DBHelper.update(id, 1);
  }

  void markTaskIncomplete(int id) async {
    await DBHelper.update(id, 0);
  }
}
