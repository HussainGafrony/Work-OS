import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workos/services/userState.dart';
import 'package:workos/widget/constants.dart';
import 'package:workos/widget/drawer.dart';
import 'package:workos/widget/globalMethod.dart';

class Profile extends StatefulWidget {
  final String userID;

  Profile({required this.userID});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var titleTextStyle = TextStyle(
      fontSize: 22, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal);
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String phoneNumber = "";
  String email = "";
  String name = "";
  String job = "";
  String? imageUrl;
  String joinedAt = "";
  bool _isSameUser = false;
  bool isloading = false;
  @override
  void initState() {
    super.initState();
    getUserDate();
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
      body: Center(
        child: isloading
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
                child: Stack(
                  children: [
                    Card(
                      margin: EdgeInsets.all(30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 80,
                            ),
                            Center(
                              child: Text(
                                name == null ? "" : name,
                                style: titleTextStyle,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Text(
                                '$job Since joined $joinedAt',
                                style: TextStyle(
                                    color: Constants.darkBlue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Contante Info ',
                              style: titleTextStyle,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            socialInfo(lable: 'Email :', contant: email),
                            SizedBox(
                              height: 10,
                            ),
                            socialInfo(
                                lable: 'Phone number :', contant: phoneNumber),
                            SizedBox(
                              height: 30,
                            ),
                            _isSameUser
                                ? Container()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      socialButtons(
                                          color: Colors.green,
                                          icon: FontAwesome5.whatsapp,
                                          function: () {
                                            _openWhatsAppChat();
                                          }),
                                      socialButtons(
                                          color: Colors.red,
                                          icon: Icons.mail_outlined,
                                          function: () {
                                            _mailTo();
                                          }),
                                      socialButtons(
                                          color: Colors.purple,
                                          icon: Icons.call_outlined,
                                          function: () {
                                            _callPhoneNumber();
                                          }),
                                    ],
                                  ),
                            SizedBox(
                              height: 20,
                            ),
                            _isSameUser
                                ? Container()
                                : Divider(
                                    thickness: 1,
                                  ),
                            SizedBox(
                              height: 20,
                            ),
                            !_isSameUser
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Center(
                                      child: MaterialButton(
                                        onPressed: () async {
                                          await _auth.signOut();

                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserState()));
                                        },
                                        color: Colors.pink.shade700,
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            side: BorderSide.none),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.logout,
                                                color: Colors.white),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('Logout',
                                                style: GoogleFonts.notoSans(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: size.width * 0.26,
                          height: size.width * 0.26,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 10,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                imageUrl == null
                                    ? 'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png'
                                    : imageUrl!,
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void _openWhatsAppChat() async {
    var whatsappUrl = 'https://wa.me/$phoneNumber?text=HelloThere';
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Error occured coulnd\'t open link';
    }
  }

  void _mailTo() async {
    var url = 'mailto:$email';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Error occured coulnd\'t open link';
    }
  }

  void _callPhoneNumber() async {
    var phoneUrl = 'tel://$phoneNumber';
    if (await canLaunch(phoneUrl)) {
      launch(phoneUrl);
    } else {
      throw "Error occured coulnd\'t open link";
    }
  }

  Widget socialInfo({required String lable, required String contant}) {
    return Row(
      children: [
        Text(
          lable,
          style: GoogleFonts.openSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            contant,
            style: GoogleFonts.openSans(
              fontSize: 16,
              color: Constants.darkBlue,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
      ],
    );
  }

  Widget socialButtons(
      {required Color color,
      required IconData icon,
      required Function function}) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 23,
        child: IconButton(
            icon: Icon(icon),
            color: color,
            onPressed: () {
              function();
            }),
      ),
    );
  }

  void getUserDate() async {
    _isLoading = true;
    print('uid ${widget.userID}');
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID)
          .get();

      if (userDoc == null) {
        return;
      } else {
        setState(() {
          email = userDoc.get('email');
          name = userDoc.get('name');
          phoneNumber = userDoc.get('phoneNumber');
          job = userDoc.get('positionCompany');
          imageUrl = userDoc.get('imageUrl');
          Timestamp joinedAtTimeStamp = userDoc.get('createdAt');
          var joinedDate = joinedAtTimeStamp.toDate();
          joinedAt = '${joinedDate.year}-${joinedDate.month}-${joinedDate.day}';
        });
        User? user = _auth.currentUser;
        String _uid = user!.uid;
        setState(() {
          _isSameUser = _uid == widget.userID;
        });
        print('_isSameUser $_isSameUser');
      }
    } on FirebaseException catch (error) {
      GlobalMethods.showErrorDialog(error: error.message, context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
