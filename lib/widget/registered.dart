import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workos/profile.dart';

class RegisteredWidget extends StatefulWidget {
  final String userId;
  final String username;
  final String userEmail;
  final String phoneNumber;

  final String postionIncompany;
  final String userImageUrl;

  const RegisteredWidget(
      {required this.userId,
      required this.username,
      required this.userEmail,
      required this.phoneNumber,
      required this.postionIncompany,
      required this.userImageUrl});

  @override
  _RegisteredWidgetState createState() => _RegisteredWidgetState();
}

class _RegisteredWidgetState extends State<RegisteredWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Profile(
                        userID: widget.userId,
                      )));
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
            child: Image.network(widget.userImageUrl == null
                ? 'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png'
                : widget.userImageUrl),
          ),
        ),
        title: Text(
          widget.username,
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
              '${widget.postionIncompany}/ ${widget.phoneNumber}',
              style: GoogleFonts.openSans(fontSize: 16),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: _mailTo,
          icon: Icon(
            Icons.mail_outline_outlined,
            size: 30,
          ),
          color: Colors.pink.shade800,
        ),
      ),
    );
  }

  void _mailTo() async {
    var url = 'mailto:${widget.userEmail}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Error occured coulnd\'t open link';
    }
  }
}
