import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workos/login.dart';
import 'package:workos/tasks.dart';

class UserState extends StatefulWidget {
  @override
  _UserStateState createState() => _UserStateState();
}

class _UserStateState extends State<UserState> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, usersnapshot) {
          if (usersnapshot.data == null) {
            print('User didn\'t login yet');
            return Login();
          } else if (usersnapshot.hasData) {
            return TasksScreen();
          } else if (usersnapshot.hasError) {
            return Center(
              child: Text(
                'An error has been occured',
                style: GoogleFonts.openSans(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: Text(
                'Something  went wrong',
                style: GoogleFonts.openSans(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
            ),
          );
        });
  }
}
