class TasksModel {
  int? id;
  String task;
  String dueDate;
  bool isChecked;

  TasksModel(
      {this.id,
      required this.task,
      required this.dueDate,
      required this.isChecked});

  Map<String, dynamic> toMap() {
    return {
      'task': task,
      'dueDate': dueDate,
      'isChecked': isChecked ? 1 : 0,
    };
  }

  factory TasksModel.fromMap(Map<String, dynamic> map) {
    return TasksModel(
      id: map['id'],
      task: map['task'],
      dueDate: map['dueDate'],
      isChecked: map['isChecked'] == 1,
    );
  }
}
