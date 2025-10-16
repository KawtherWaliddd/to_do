import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import '../db_helper/db_helper.dart';
import '../models/tasks_model.dart';
import '../widget/taskIteam.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController date = TextEditingController();
  TextEditingController name = TextEditingController();
  String year = DateTime.now().year.toString();
  String day = DateTime.now().day.toString();

  String getCurrentDayName() {
    return formatDate(DateTime.now(), [D]);
  }

  String getCurrentMonthName() {
    return formatDate(DateTime.now(), [M]);
  }

  late DbHelper dbHelper;
  bool isCheck = false;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          setState(() {
            name.clear();
            date.clear();
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("New Task"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: name,
                        decoration: const InputDecoration(hintText: "Name"),
                      ),
                      TextFormField(
                        controller: date,
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: "No due date",
                        ),
                        onTap: () async {
                          selectedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                            initialDate: DateTime.now(),
                          );
                          setState(() {
                            if (selectedDate != null) {
                              date.text = formatDate(
                                  selectedDate!, [yyyy, '-', mm, '-', dd]);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel",
                          style: TextStyle(color: Colors.black)),
                    ),
                    TextButton(
                      onPressed: () async {
                        TasksModel tasksModel = TasksModel(
                          task: name.text,
                          dueDate: date.text,
                          isChecked: isCheck,
                        );

                        await dbHelper
                            .insertDataIntoDatabase(tasksModel)
                            .then((value) {
                          Navigator.of(context).pop();
                          setState(() {});
                        });
                      },
                      child: const Text("Save",
                          style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                );
              },
            );
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Tasker",
          style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            minVerticalPadding: 35,
            tileColor: Colors.blue,
            title: Text(
              getCurrentMonthName(),
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              year,
              style: const TextStyle(color: Colors.white),
            ),
            leading: Text(
              day,
              style: const TextStyle(color: Colors.white, fontSize: 45),
            ),
            trailing: Text(
              getCurrentDayName(),
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          FutureBuilder(
            future: dbHelper.getDataFromDatabase(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text("Error loading tasks");
              } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      TasksModel tasksModel =
                      TasksModel.fromMap(snapshot.data[index]);
                      return Taskiteam(tasksModel: tasksModel);
                    },
                  ),
                );
              } else {
                return const Center(
                  child: Text(
                    "No tasks available.",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
