import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:workos/widget/constants.dart';
import 'package:workos/widget/drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workos/widget/globalMethod.dart';

class Add_Task extends StatefulWidget {
  _Add_TaskState createState() => _Add_TaskState();
}

class _Add_TaskState extends State<Add_Task> {
  TextEditingController categorycontroller =
      TextEditingController(text: 'task Category');
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  TextEditingController deadlineDatecontroller =
      TextEditingController(text: 'pick up a date');
  final keyuploade = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  DateTime? packed;
  Timestamp? deadlineDateTimeStamp;
  bool isLoading = false;
  @override
  void dispose() {
    categorycontroller.dispose();
    titlecontroller.dispose();
    descriptioncontroller.dispose();
    deadlineDatecontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Constants.darkBlue),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      drawer: DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'All field are required',
                      style: GoogleFonts.openSans(
                          fontSize: 25,
                          color: Constants.darkBlue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                ),
                Form(
                  key: keyuploade,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textsWidget(textlable: 'Task Category*'),
                      textformfield(
                          valuekey: 'Task Category',
                          controller: categorycontroller,
                          enabled: false,
                          function: () {
                            show_Task_Category_Dialoge(size);
                          },
                          maxlength: 100),
                      textsWidget(textlable: 'Task Title*'),
                      textformfield(
                          valuekey: 'Task title',
                          controller: titlecontroller,
                          enabled: true,
                          function: () {},
                          maxlength: 100),
                      textsWidget(textlable: 'Task Describtion*'),
                      textformfield(
                          valuekey: 'Task Describtion',
                          controller: descriptioncontroller,
                          enabled: true,
                          function: () {},
                          maxlength: 1000),
                      textsWidget(textlable: 'Task Deadline date*'),
                      textformfield(
                          valuekey: 'Deadline Date',
                          controller: deadlineDatecontroller,
                          enabled: false,
                          function: () {
                            pisckedDate();
                          },
                          maxlength: 100),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Center(
                          child: isLoading
                              ? CircularProgressIndicator(
                                  color: Constants.darkBlue,
                                )
                              : MaterialButton(
                                  onPressed: uploade,
                                  color: Colors.pink.shade700,
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: BorderSide.none),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Uploade',
                                          style: GoogleFonts.notoSans(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(Icons.upload_file,
                                          color: Colors.white),
                                    ],
                                  )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future pisckedDate() async {
    packed = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 0)),
        lastDate: DateTime(2100));
    if (packed != null) {
      setState(() {
        deadlineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
            packed!.millisecondsSinceEpoch);
        deadlineDatecontroller.text =
            '${packed!.year}-${packed!.month}-${packed!.day}';
      });
    }
  }

  void uploade() async {
    String userID = auth.currentUser!.uid;
    final isValid = keyuploade.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      if (deadlineDatecontroller.text == 'pick up a date' ||
          categorycontroller.text == 'task Category') {
        GlobalMethods.showErrorDialog(
            context: context, error: 'please pick up everything');
        return;
      }
      setState(() {
        isLoading = true;
      });
      try {
        final taskID = Uuid().v4();
        await FirebaseFirestore.instance.collection('tasks').doc(taskID).set({
          'taskID': taskID,
          'uploadedBy': userID,
          'taskTitle': titlecontroller.text,
          'taskDescription': descriptioncontroller.text,
          'deadLineDate': deadlineDatecontroller.text,
          'deadlineDateTimeStamp': deadlineDateTimeStamp,
          'taskCategory': categorycontroller.text,
          'taskComments': [],
          'isDone': false,
          'createdAt': Timestamp.now(),
        });

        Fluttertoast.showToast(
            msg: "Task has been uploaded successfuly",
            textColor: Constants.darkBlue,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Theme.of(context).cardColor,
            fontSize: 16.0);

        descriptioncontroller.clear();
        titlecontroller.clear();
        setState(() {
          categorycontroller.text = 'Task Category';
          deadlineDatecontroller.text = 'pick up a date';
        });
      } on FirebaseException catch (error) {} finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print('form not valid');
    }
  }

  dynamic textsWidget({required String textlable}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        textlable,
        style: GoogleFonts.openSans(
            fontSize: 18, color: Colors.pink[800], fontWeight: FontWeight.bold),
      ),
    );
  }

  void show_Task_Category_Dialoge(size) {
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
                        setState(() {
                          categorycontroller.text =
                              Constants.tasksCategoryList[index];
                        });
                        Navigator.pop(context);
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
            ],
          );
        });
  }

  dynamic textformfield(
      {required String valuekey,
      required TextEditingController controller,
      required bool enabled,
      required Function function,
      required int maxlength}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          function();
        },
        child: TextFormField(
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Field is missing';
            }
            return null;
          },
          enabled: enabled,
          key: ValueKey(valuekey),
          style: GoogleFonts.openSans(
              color: Constants.darkBlue,
              fontStyle: FontStyle.italic,
              fontSize: 18,
              fontWeight: FontWeight.bold),
          maxLines: valuekey == 'Task Describtion' ? 3 : 1,
          maxLength: maxlength,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.pink.shade800)),
          ),
        ),
      ),
    );
  }
}
