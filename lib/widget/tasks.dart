import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workos/Screens/inner_screens/tasksDetails.dart';
import 'package:workos/widget/globalMethod.dart';

class TasksWidget extends StatefulWidget {
  final String taskID;
  final String taskTitle;
  final String taskDescription;
  final String uploadedBY;
  final bool isDone;

  const TasksWidget(
      {required this.taskID,
      required this.taskTitle,
      required this.taskDescription,
      required this.uploadedBY,
      required this.isDone});

  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TaskDetails(
                        taskId: widget.taskID,
                        uploadedBy: widget.uploadedBY,
                      )));
        },
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  contentPadding: EdgeInsets.all(0),
                  content: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      String user = auth.currentUser!.uid;
                      if (user == widget.uploadedBY) {
                        FirebaseFirestore.instance
                            .collection('tasks')
                            .doc(widget.taskID)
                            .delete();
                        Navigator.pop(context);
                      } else {
                        GlobalMethods.showErrorDialog(
                            context: context,
                            error: 'You dont have access to delete this task');
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Delete',
                          style: GoogleFonts.openSans(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            ),
          ),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.transparent,
            child: Image.network(widget.isDone
                ? 'https://image.flaticon.com/icons/png/128/390/390973.png'
                : 'https://image.flaticon.com/icons/png/128/850/850960.png'),
          ),
        ),
        title: Text(
          widget.taskTitle,
          style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.linear_scale,
              color: Colors.pink.shade800,
            ),
            Text(
              widget.taskDescription,
              style: GoogleFonts.openSans(fontSize: 16),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Colors.pink.shade800,
        ),
      ),
    );
  }
}
