import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workos/widget/constants.dart';
import 'package:workos/widget/drawer.dart';
import 'package:workos/widget/tasks.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String? tasksCategory;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('Tasks',
            style: GoogleFonts.openSans(
                color: Colors.pink, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              icon: Icon(Icons.category, color: Colors.black),
              onPressed: () {
                show_Task_Category_Dialoge(context, size);
              }),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .where('taskCategory', isEqualTo: tasksCategory)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return TasksWidget(
                      taskID: snapshot.data!.docs[index]['taskID'],
                      taskTitle: snapshot.data!.docs[index]['taskTitle'],
                      taskDescription: snapshot.data!.docs[index]
                          ['taskDescription'],
                      isDone: snapshot.data!.docs[index]['isDone'],
                      uploadedBY: snapshot.data!.docs[index]['uploadedBy'],
                    );
                  });
            } else {
              return Center(
                child: Text('No tasks has been uploaded'),
              );
            }
          } else {
            return Center(
              child: Text('Something went wrong'),
            );
          }
        },
      ),
    );
  }

  show_Task_Category_Dialoge(context, size) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Task category',
              style: GoogleFonts.openSans(
                  color: Colors.pink.shade300, fontSize: 20),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Constants.tasksCategoryList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        print(Constants.tasksCategoryList[index]);
                        setState(() {
                          if (tasksCategory == null) {
                            return;
                          }
                          tasksCategory = Constants.tasksCategoryList[index];
                        });
                        Navigator.canPop(context)
                            ? Navigator.pop(context)
                            : null;
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: Colors.red[200],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Constants.tasksCategoryList[index],
                              style: GoogleFonts.openSans(
                                fontSize: 20,
                                color: Color(0xFF00325A),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                  setState(() {
                    tasksCategory = null;
                  });
                },
                child: Text('Cancel filter'),
              ),
            ],
          );
        });
  }
}
