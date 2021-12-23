import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workos/forgetPassword.dart';
import 'package:workos/register.dart';
import 'package:workos/widget/globalMethod.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
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

  void dispose() {
    animationController!.dispose();
    emailcontroller!.dispose();
    passwordcontroller!.dispose();

    passwordfocus.dispose();

    super.dispose();
  }

  TextEditingController? emailcontroller = TextEditingController();
  TextEditingController? passwordcontroller = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final keylogin = GlobalKey<FormState>();
  AnimationController? animationController;
  Animation<double>? animation;
  FocusNode passwordfocus = FocusNode();
  bool visibilPassword = true;
  IconData? visibility;
  String? errorMessage;

  bool isLodaing = false;

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
                  'Login',
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
                      text: 'Don\'t have an account? ',
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
                      text: 'Register',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Signup())),
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

                // email Controller
                Form(
                  key: keylogin,
                  child: Column(
                    children: [
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => passwordfocus.requestFocus(),
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'please enter a valid Email adress';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        controller: emailcontroller,
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
                        textInputAction: TextInputAction.done,
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
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),

                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgetPassword()));
                    },
                    child: Text(
                      'Forget Password?',
                      style: GoogleFonts.openSans(
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
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
                          onPressed: submitLogin,
                          color: Colors.pink.shade700,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide.none),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Login',
                                  style: GoogleFonts.notoSans(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.login, color: Colors.white),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void submitLogin() async {
    final isValid = keylogin.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        isLodaing = true;
      });
      try {
        await _auth.signInWithEmailAndPassword(
            email: emailcontroller!.text.trim(),
            password: passwordcontroller!.text.trim());
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            setState(() {
              errorMessage = 'please re-check your email';
            });
            break;
          case "wrong-password":
            setState(() {
              errorMessage = 'your password is wrong';
            });
            break;
          case "user-not-found":
            setState(() {
              errorMessage = 'your email does not exists';
            });
            break;
          case "user-disabled":
            setState(() {
              errorMessage = 'Your account has been disabled';
            });
            break;
          case "too-many-requests":
            setState(() {
              errorMessage = 'please wait';
            });
            break;
          case "operation-not-allowed":
            setState(() {
              errorMessage = 'you blocked';
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
}
