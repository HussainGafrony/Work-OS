import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart' as p;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workos/widget/constants.dart';
import 'package:workos/login.dart';
import 'package:workos/widget/globalMethod.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> with TickerProviderStateMixin {
  TextEditingController? emailcontroller = TextEditingController(text: '');
  TextEditingController? namecontroller = TextEditingController(text: '');
  TextEditingController? positioncontroller = TextEditingController(text: '');
  TextEditingController? passwordcontroller = TextEditingController(text: '');
  TextEditingController? phonecontroller = TextEditingController(text: '');
  FocusNode emailfocus = FocusNode();
  FocusNode passwordfocus = FocusNode();
  FocusNode phonefocus = FocusNode();
  FocusNode positionfocus = FocusNode();
  AnimationController? animationController;
  Animation<double>? animation;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLodaing = false;
  String? errorMessage;
  bool visibilPassword = true;
  IconData? visibility;
  final keySignup = GlobalKey<FormState>();
  File? imageFile;
  String? url;

  @override
  void dispose() {
    animationController!.dispose();
    emailcontroller!.dispose();
    passwordcontroller!.dispose();
    namecontroller!.dispose();
    positioncontroller!.dispose();
    emailfocus.dispose();
    passwordfocus.dispose();
    positionfocus.dispose();
    phonecontroller!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 20));
    animation =
        CurvedAnimation(curve: Curves.linear, parent: animationController!)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              animationController!.reset();
              animationController!.forward();
            }
          });
    animationController!.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl:
                "https://media.istockphoto.com/photos/businesswoman-using-computer-in-dark-office-picture-id557608443?k=6&m=557608443&s=612x612&w=0&h=fWWESl6nk7T6ufo4sRjRBSeSiaiVYAzVrY-CLlfMptM=",
            placeholder: (context, url) => Image.asset(
              'assets/images/wallpaper.jpg',
            ),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            alignment: FractionalOffset(animation!.value, 0),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                Text(
                  'Register',
                  style: GoogleFonts.notoSans(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 9,
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Already  have an account? ',
                      style: GoogleFonts.notoSans(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' ',
                    ),
                    TextSpan(
                      text: 'Login',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login())),
                      style: GoogleFonts.notoSans(
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                ),
                SizedBox(height: size.height * 0.05),

                // name Controller
                Form(
                  key: keySignup,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex: 2,

                            ///  name Controller
                            child: TextFormField(
                              onFieldSubmitted: (_) =>
                                  emailfocus.requestFocus(),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Field can\'t be missing';
                                }
                                return null;
                              },
                              controller: namecontroller,
                              style: GoogleFonts.openSans(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'FullName',
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.4),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.pink.shade700),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, top: 8, right: 8, bottom: 8),
                                  child: Container(
                                    width: size.width * 0.24,
                                    height: size.width * 0.24,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.white),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: imageFile == null
                                          ? Image.network(
                                              'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png',
                                              fit: BoxFit.fill)
                                          : Image.file(imageFile!,
                                              fit: BoxFit.fill),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () => showimageDialog(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.pink,
                                          border: Border.all(
                                              width: 2, color: Colors.white),
                                          shape: BoxShape.circle),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                            imageFile == null
                                                ? Icons.add_a_photo
                                                : Icons.edit_outlined,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      /// email Controller
                      TextFormField(
                        focusNode: emailfocus,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'please enter a valid Email adress';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        controller: emailcontroller,
                        onFieldSubmitted: (_) => passwordfocus.requestFocus(),
                        style: GoogleFonts.openSans(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.4),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.pink.shade700),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      // password Controller

                      TextFormField(
                        textInputAction: TextInputAction.next,
                        focusNode: passwordfocus,
                        onFieldSubmitted: (_) => phonefocus.requestFocus(),
                        obscureText: visibilPassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter a valid Password ';
                          } else if (value.length < 7) {
                            return 'Password is less than 8 characters';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.visiblePassword,
                        controller: passwordcontroller,
                        style: GoogleFonts.openSans(color: Colors.white),
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                visibilPassword = !visibilPassword;
                              });
                            },
                            child: Icon(
                                (visibilPassword == true)
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: (visibilPassword == true)
                                    ? Colors.white
                                    : Colors.grey),
                          ),
                          hintText: 'Password',
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.4),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.pink.shade700),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),

                      /// phone Controller
                      TextFormField(
                        focusNode: phonefocus,
                        keyboardType: TextInputType.phone,
                        // onChanged: (value) {
                        //   print('$value');
                        // },
                        onFieldSubmitted: (_) => positionfocus.requestFocus(),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Field can\'t be missing';
                          }
                          return null;
                        },
                        controller: phonecontroller,
                        style: GoogleFonts.openSans(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Phone number',
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.4),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.pink.shade700),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 15,
                      ),

                      /// Position Controller
                      GestureDetector(
                        onTap: () => showJopsList(size),
                        child: TextFormField(
                          focusNode: positionfocus,
                          enabled: false,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Field can\'t be missing ';
                            }
                            return null;
                          },
                          controller: positioncontroller,
                          style: GoogleFonts.openSans(color: Colors.white),
                          decoration: InputDecoration(
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            hintText: 'Position in the company',
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.4),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.pink.shade700),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 40,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: isLodaing
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        )
                      : MaterialButton(
                          onPressed: submitSignup,
                          color: Colors.pink.shade700,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide.none),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Register',
                                  style: GoogleFonts.notoSans(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.person_add, color: Colors.white),
                            ],
                          )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void submitSignup() async {
    final isValid = keySignup.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      if (imageFile == null) {
        GlobalMethods.showErrorDialog(
            context: context, error: 'please pick up an image');
        return;
      }
      setState(() {
        isLodaing = true;
      });
      try {
        await _auth.createUserWithEmailAndPassword(
            email: emailcontroller!.text.trim(),
            password: passwordcontroller!.text.trim());
        final userID = FirebaseAuth.instance.currentUser!.uid;
        final ref = FirebaseStorage.instance
            .ref()
            .child('userImages')
            .child('$userID + .jpeg + ${DateTime.now()}');

        await ref.putFile(imageFile!);

        await ref.getDownloadURL().then((imageUrl) async {
          await FirebaseFirestore.instance.collection('users').doc(userID).set({
            'id': userID,
            'name': namecontroller!.text,
            'email': emailcontroller!.text,
            'imageUrl': imageUrl != null ? imageUrl : " ",
            'phoneNumber': phonecontroller!.text,
            'positionCompany': positioncontroller!.text,
            'createdAt': Timestamp.now(),
          });
          print('Uploaded image');
        });

        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "email-already-in-use":
            setState(() {
              errorMessage = 'email-already-in-use';
            });
            break;
          case "invalid-email":
            setState(() {
              errorMessage = 'invalid-email';
            });
            break;
          case "operation-not-allowed":
            setState(() {
              errorMessage = 'This service is not activated';
            });
            break;
          case "weak-password":
            setState(() {
              errorMessage = 'weak-password';
            });
            break;

          default:
            setState(() {
              errorMessage = 'unexpected error';
            });
            break;
        }
        setState(() {
          isLodaing = false;
        });
        GlobalMethods.showErrorDialog(context: context, error: error.message);
        print('error not valid : $error');
      }
    } else {
      print('Form not valid');
    }
    setState(() {
      isLodaing = false;
    });
  }

  void showJopsList(size) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Jops',
              style: GoogleFonts.openSans(
                  color: Colors.pink.shade300, fontSize: 20),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Constants.jopsList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          positioncontroller!.text = Constants.jopsList[index];
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
                              Constants.jopsList[index],
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
                onPressed: () {},
                child: Text('Cancel filter'),
              ),
            ],
          );
        });
  }

  Future _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker()
          .pickImage(source: source, maxHeight: 1080, maxWidth: 1080);
      if (pickedFile == null) {
        return;
      }
      var cropiamge = await ImageCropper.cropImage(sourcePath: pickedFile.path);
      if (cropiamge == null) {
        return;
      }
      cropiamge = await compressImage(cropiamge.path);
      if (cropiamge != null) {
        setState(() {
          imageFile = cropiamge;
        });
      }
    } on FirebaseException catch (error) {
      print(error.message);
      GlobalMethods.showErrorDialog(context: context, error: error.message);
    }

    Navigator.pop(context);
  }

  Future<File?> compressImage(String path) async {
    final newpath =
        p.join((await getTemporaryDirectory()).path, '${p.extension(path)}');
    final result = await FlutterImageCompress.compressAndGetFile(
      path,
      newpath,
      format: CompressFormat.jpeg,
    );
    return result;
  }

  showimageDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Please choose an options',
              style: GoogleFonts.openSans(),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    _pickImage(ImageSource.camera);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.camera, color: Colors.purple),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        'Camera',
                        style: GoogleFonts.openSans(color: Colors.purple),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        Icon(Icons.image_search, color: Colors.purple),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          'Gallery',
                          style: GoogleFonts.openSans(color: Colors.purple),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
