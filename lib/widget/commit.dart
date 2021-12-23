import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workos/Screens/drawer/profile.dart';

class CommitWidget extends StatelessWidget {
  final String commentID;
  final String commentBody;
  final String commentImageUrl;
  final String commentName;
  final String commentId;

  List<Color> colors = [
    Colors.orangeAccent,
    Colors.pink,
    Colors.amber,
    Colors.purple,
    Colors.brown,
    Colors.blue,
  ];

  CommitWidget(
      {required this.commentID,
      required this.commentBody,
      required this.commentImageUrl,
      required this.commentName,
      required this.commentId});
  @override
  Widget build(BuildContext context) {
    colors.shuffle();

    /// Shuffles the elements of this list randomly
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Profile(
                      userID: commentId,
                    )));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 5,
          ),
          Flexible(
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: colors[0]),
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(commentImageUrl), fit: BoxFit.fill),
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    commentName,
                    style: GoogleFonts.openSans(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    commentBody,
                    style: GoogleFonts.openSans(
                        fontStyle: FontStyle.italic, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
