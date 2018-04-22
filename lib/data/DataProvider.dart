import 'package:clean_todo/beans/CategoryData.dart';
import 'package:clean_todo/beans/UserData.dart';
import 'package:clean_todo/beans/Task.dart';

abstract class DataProvider {

  CategoryData getSidebarData();
  UserData getUserData();
  List<Task> getAllTasks();

}