import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:workos/widget/constants.dart';
import 'package:workos/widget/commit.dart';
import 'package:workos/widget/globalMethod.dart';

class TaskDetails extends StatefulWidget {
  final String taskId;
  final String uploadedBy;

  const TaskDetails({required this.taskId, required this.uploadedBy});
  @override
  _TaskDetailsState createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  var textStyle = GoogleFonts.openSans(
      fontSize: 15, fontWeight: FontWeight.bold, color: Constants.darkBlue);
  TextEditingController commitecontroller = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  bool isCommit = false;
  String? authorName;
  String? authorPosition;
  String? taskDescription;
  String? taskTitle;
  bool? isDone;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadlineDateTimeStamp;
  String? deadlineDate;
  String? postedDate;
  bool isDeadlineAvailable = false;
  String? userImage;
  bool isloading = false;

  void initState() {
    super.initState();
    getDate();
  }

  @override
  void dispose() {
    commitecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,

          /// hide arrow back
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: TextButton(
            child: Text(
              'Back',
              style: GoogleFonts.openSans(
                color: Constants.darkBlue,
                fontStyle: FontStyle.italic,
                fontSize: 20,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: isloading
            ? Center(
                child: Text(
                  'Fetching data',
                  style: GoogleFonts.openSans(
                    color: Constants.darkBlue,
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Text(
                        taskTitle == null ? "loading" : taskTitle!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Constants.darkBlue,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'uploaded by',
                                    style: GoogleFonts.openSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Constants.darkBlue),
                                  ),
                                  Spacer(),
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 3,
                                          color: Colors.pink.shade800),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            userImage == null
                                                ? 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png'
                                                : userImage!,
                                          ),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          authorName == null
                                              ? ' loading'
                                              : authorName!,
                                          style: textStyle),
                                      Text(
                                          authorPosition == null
                                              ? 'loading'
                                              : authorPosition!,
                                          style: textStyle),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(thickness: 1),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'uploaded on:',
                                    style: GoogleFonts.openSans(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Constants.darkBlue),
                                  ),
                                  Text(
                                    postedDate == null ? '' : postedDate!,
                                    style: GoogleFonts.openSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: Constants.darkBlue),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Deadline date:',
                                    style: GoogleFonts.openSans(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Constants.darkBlue),
                                  ),
                                  Text(
                                    deadlineDate == null ? '' : deadlineDate!,
                                    style: GoogleFonts.openSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text(
                                  isDeadlineAvailable
                                      ? "Still have enough time "
                                      : 'No time left',
                                  style: GoogleFonts.openSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: isDeadlineAvailable
                                          ? Colors.green
                                          : Colors.red),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(thickness: 1),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Done state:',
                                style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Constants.darkBlue),
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: TextButton(
                                      onPressed: () {
                                        String user = auth.currentUser!.uid;
                                        if (user == widget.uploadedBy) {
                                          FirebaseFirestore.instance
                                              .collection('tasks')
                                              .doc(widget.taskId)
                                              .update({'isDone': true});
                                          getDate();
                                        } else {
                                          GlobalMethods.showErrorDialog(
                                              context: context,
                                              error:
                                                  'You can\'t perform this action');
                                        }
                                      },
                                      child: Text(
                                        'Done',
                                        style: GoogleFonts.openSans(
                                            decoration: isDone == true
                                                ? TextDecoration.underline
                                                : TextDecoration.none,
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                            color: Constants.darkBlue),
                                      ),
                                    ),
                                  ),
                                  Opacity(
                                    opacity: isDone == true ? 1 : 0,
                                    child: Icon(
                                      Icons.check_box,
                                      color: Colors.green,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Flexible(
                                    child: TextButton(
                                      onPressed: () {
                                        String user = auth.currentUser!.uid;
                                        if (user == widget.uploadedBy) {
                                          FirebaseFirestore.instance
                                              .collection('tasks')
                                              .doc(widget.taskId)
                                              .update({'isDone': false});
                                          getDate();
                                        } else {
                                          GlobalMethods.showErrorDialog(
                                              context: context,
                                              error:
                                                  'You can\'t perform this action');
                                        }
                                      },
                                      child: Text(
                                        'Not done',
                                        style: GoogleFonts.openSans(
                                            decoration: isDone == false
                                                ? TextDecoration.underline
                                                : TextDecoration.none,
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                            color: Constants.darkBlue),
                                      ),
                                    ),
                                  ),
                                  Opacity(
                                    opacity: isDone == false ? 1 : 0,
                                    child: Icon(
                                      Icons.check_box,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(thickness: 1),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Task description:',
                                style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Constants.darkBlue),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                taskDescription == null
                                    ? 'loading'
                                    : taskDescription!,
                                style: GoogleFonts.openSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Constants.darkBlue,
                                    fontStyle: FontStyle.italic),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              AnimatedSwitcher(
                                duration: Duration(milliseconds: 500),
                                child: isCommit
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            child: TextField(
                                              controller: commitecontroller,
                                              keyboardType: TextInputType.text,
                                              maxLines: 6,
                                              maxLength: 200,
                                              style: GoogleFonts.openSans(
                                                color: Constants.darkBlue,
                                              ),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                                errorBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.red),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.pink),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 14),
                                                  child: MaterialButton(
                                                    onPressed: () {
                                                      addCominte();
                                                    },
                                                    color: Colors.pink.shade700,
                                                    elevation: 10,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            side: BorderSide
                                                                .none),
                                                    child: Text('Post',
                                                        style: GoogleFonts
                                                            .notoSans(
                                                          fontSize: 18,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      isCommit = !isCommit;
                                                    });
                                                  },
                                                  child: Text(
                                                    'Cancel',
                                                    style: GoogleFonts.openSans(
                                                      fontSize: 16,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14),
                                          child: MaterialButton(
                                            onPressed: () {
                                              setState(() {
                                                isCommit = !isCommit;
                                              });
                                            },
                                            color: Colors.pink.shade700,
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: BorderSide.none),
                                            child: Text(
                                              'Add a comment',
                                              style: GoogleFonts.notoSans(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('tasks')
                                    .doc(widget.taskId)
                                    .get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.data == null) {
                                    return Container();
                                  }
                                  return ListView.separated(
                                      reverse: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return CommitWidget(
                                          commentID:
                                              snapshot.data!['taskComments']
                                                  [index]['commentID'],
                                          commentBody:
                                              snapshot.data!['taskComments']
                                                  [index]['commentBody'],
                                          commentId:
                                              snapshot.data!['taskComments']
                                                  [index]['userID'],
                                          commentName:
                                              snapshot.data!['taskComments']
                                                  [index]['name'],
                                          commentImageUrl:
                                              snapshot.data!['taskComments']
                                                  [index]['userImage'],
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return Divider(thickness: 1);
                                      },
                                      itemCount: snapshot
                                          .data!['taskComments'].length);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  getDate() async {
    setState(() {
      isloading = true;
    });
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uploadedBy)
          .get();
      // ignore: unnecessary_null_comparison
      if (userDoc == null) {
        return;
      } else {
        setState(() {
          authorName = userDoc.get('name');
          authorPosition = userDoc.get('positionCompany');
          userImage = userDoc.get('imageUrl');
        });
      }
      final DocumentSnapshot taskDatabase = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .get();
      // ignore: unnecessary_null_comparison
      if (taskDatabase == null) {
        return;
      } else {
        setState(() {
          taskDescription = taskDatabase.get('taskDescription');
          taskTitle = taskDatabase.get('taskTitle');
          print(taskTitle);
          isDone = taskDatabase.get('isDone');
          deadlineDate = taskDatabase.get('deadLineDate');
          deadlineDateTimeStamp = taskDatabase.get('deadlineDateTimeStamp');
          postedDateTimeStamp = taskDatabase.get('createdAt');
          var postDate = postedDateTimeStamp!.toDate();
          postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';
          var date = deadlineDateTimeStamp!.toDate();
          isDeadlineAvailable = date.isAfter(DateTime.now());
        });
      }
    } on FirebaseException catch (error) {
      GlobalMethods.showErrorDialog(context: context, error: error.message);
    } finally {
      isloading = false;
    }
  }

  addCominte() async {
    if (commitecontroller.text.length < 7) {
      GlobalMethods.showErrorDialog(
          context: context, error: 'Comment cant be less than 7 characteres');
    } else {
      final generatedID = Uuid().v4();
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .update({
        'taskComments': FieldValue.arrayUnion([
          {
            'userID': widget.uploadedBy,
            'commentID': generatedID,
            'name': authorName,
            'commentBody': commitecontroller.text.trim(),
            'userImage': userImage,
            'time': Timestamp.now(),
          }
        ]),
      });

      await Fluttertoast.showToast(
          msg: "Comment has been uploaded successfuly",
          textColor: Constants.darkBlue,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Theme.of(context).cardColor,
          fontSize: 16.0);
      commitecontroller.clear();
      setState(() {});
    }
  }
}
