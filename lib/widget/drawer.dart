import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workos/addTasks.dart';
import 'package:workos/profile.dart';
import 'package:workos/registerWorkes.dart';
import 'package:workos/tasks.dart';
import 'package:workos/userState.dart';
import 'package:workos/widget/constants.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.cyan),
            child: Column(
              children: [
                Flexible(
                  child: Image.network(
                      'https://image.flaticon.com/icons/png/128/1055/1055672.png'),
                ),
                SizedBox(
                  height: 20,
                ),
                Flexible(
                  child: Text(
                    'Work OS Arabic',
                    style: GoogleFonts.openSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Constants.darkBlue,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          widget_listTile(
              lable: 'All tasks',
              icon: Icons.assignment_turned_in_sharp,
              function: () {
                navigate_To_Task_Screen(context);
              }),
          widget_listTile(
              lable: 'My account',
              icon: Icons.settings_outlined,
              function: () {
                navigate_To_Profile_Screen(context);
              }),
          widget_listTile(
              lable: 'Registered workes',
              icon: Icons.workspaces_outline,
              function: () {
                navigate_To_Registered_Workes_Screen(context);
              }),
          widget_listTile(
              lable: 'Add task',
              icon: Icons.assignment,
              function: () {
                navigate_To_Add_Task(context);
              }),
          Divider(
            thickness: 1,
          ),
          widget_listTile(
              lable: 'Logout',
              icon: Icons.login_outlined,
              function: () {
                logout(context);
              }),
        ],
      ),
    );
  }

  void navigate_To_Profile_Screen(context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Profile(
                  userID: userId,
                )));
  }

  void navigate_To_Task_Screen(context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => TasksScreen()));
  }

  void navigate_To_Registered_Workes_Screen(context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Registered_Works()));
  }

  void navigate_To_Add_Task(context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Add_Task()));
  }

  void logout(context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    'https://image.flaticon.com/icons/png/128/1252/1252006.png',
                    height: 20,
                    width: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Sign out'),
                ),
              ],
            ),
            content: Text(
              'Do you want sign out',
              style: TextStyle(
                  color: Constants.darkBlue,
                  fontSize: 20,
                  fontStyle: FontStyle.italic),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: Text('Cancel', style: TextStyle(fontSize: 20)),
              ),
              TextButton(
                onPressed: () async {
                  await auth.signOut();
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => UserState()));
                },
                child: Text('ok',
                    style: TextStyle(color: Colors.red, fontSize: 20)),
              ),
            ],
          );
        });
  }

  widget_listTile(
      {required String lable,
      required IconData icon,
      required Function function}) {
    return ListTile(
      onTap: () {
        function();
      },
      title: Text(
        lable,
        style: TextStyle(
            color: Constants.darkBlue,
            fontSize: 20,
            fontStyle: FontStyle.italic),
      ),
      leading: Icon(
        icon,
        color: Constants.darkBlue,
      ),
    );
  }
}
