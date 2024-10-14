class Task {
  final int id;
  String title;
  String description;
  DateTime dueDateTime;
  String color;
  bool isDone = false;

  Task({required this.id, required this.title, required this.description, required this.dueDateTime, required this.color});
}