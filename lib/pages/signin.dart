// import 'package:flutter/material.dart';
// import 'package:bloom/reusable_widgets/reusable_widget.dart';
// import 'package:bloom/pages/signup.dart';
// import 'package:bloom/pages/profile.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class SignInPage extends StatefulWidget {
//   const SignInPage({super.key});

//   @override
//   State<SignInPage> createState() => _SignInPageState();
// }

// class _SignInPageState extends State<SignInPage> {
//   TextEditingController _passwordTextController = TextEditingController();
//   TextEditingController _emailTextController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
//     double h = MediaQuery.of(context).size.height;

//     return Scaffold(
//         body: Container(
//       height: h,
//       width: w,
//       // decoration: BoxDecoration(
//       //   gradient: const RadialGradient(
//       //     colors: [Colors.red, Colors.yellow],
//       //     radius: 0.75,
//       //   ),
//       // ),
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Container(
//             //     width: w,
//             //     height: h * 0.3,
//             //     child: Align(
//             //         alignment: Alignment(0.0, 0.5),
//             //         child: logoWidget('assets/images/bloom_icon1.png'))),
//             SizedBox(height: h * 0.25),
//             Container(
//               child: Column(
//                 children: [
//                   Text(
//                     "Hello",
//                     style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     "Sign into your account",
//                     style: TextStyle(fontSize: 15),
//                   ),
//                   SizedBox(height: 50),
//                   // Container(
//                   //     decoration: BoxDecoration(
//                   //         color: Colors.white,
//                   //         borderRadius: BorderRadius.circular(30),
//                   //         boxShadow: [
//                   //           BoxShadow(
//                   //               blurRadius: 10,
//                   //               spreadRadius: 7,
//                   //               offset: Offset(1, 1),
//                   //               color: Colors.grey.withOpacity(0.2))
//                   //         ]),
//                   //     child: TextField(
//                   //       decoration: InputDecoration(
//                   //           focusedBorder: OutlineInputBorder(
//                   //               borderRadius: BorderRadius.circular(30),
//                   //               borderSide: BorderSide(
//                   //                   color: Colors.white, width: 1.0)),
//                   //           enabledBorder: OutlineInputBorder(
//                   //               borderRadius: BorderRadius.circular(30),
//                   //               borderSide: BorderSide(
//                   //                   color: Colors.white, width: 1.0)),
//                   //           border: OutlineInputBorder(
//                   //               borderRadius: BorderRadius.circular(30))),
//                   //     )),
//                   reusableTextField(
//                       'Enter email', false, context, _emailTextController),
//                   SizedBox(height: 20),
//                   // Container(
//                   //     decoration: BoxDecoration(
//                   //         color: Colors.white,
//                   //         borderRadius: BorderRadius.circular(30),
//                   //         boxShadow: [
//                   //           BoxShadow(
//                   //               blurRadius: 10,
//                   //               spreadRadius: 7,
//                   //               offset: Offset(1, 1),
//                   //               color: Colors.grey.withOpacity(0.2))
//                   //         ]),
//                   //     child: TextField(
//                   //       decoration: InputDecoration(
//                   //           focusedBorder: OutlineInputBorder(
//                   //               borderRadius: BorderRadius.circular(30),
//                   //               borderSide: BorderSide(
//                   //                   color: Colors.white, width: 1.0)),
//                   //           enabledBorder: OutlineInputBorder(
//                   //               borderRadius: BorderRadius.circular(30),
//                   //               borderSide: BorderSide(
//                   //                   color: Colors.white, width: 1.0)),
//                   //           border: OutlineInputBorder(
//                   //               borderRadius: BorderRadius.circular(30))),
//                   //     )),
//                   reusableTextField('Enter password', false, context,
//                       _passwordTextController),
//                   SizedBox(height: 20),
//                   Text(
//                     "Forgot your Password?",
//                     style: TextStyle(fontSize: 15),
//                   ),
//                   SizedBox(height: 40),
//                   firebaseUIButton(context, "Sign In", () {
//                     FirebaseAuth.instance
//                         .signInWithEmailAndPassword(
//                             email: _emailTextController.text,
//                             password: _passwordTextController.text)
//                         .then((value) {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => ProfilePage()));
//                     }).onError((error, stackTrace) {
//                       print("Error ${error.toString()}");
//                     });
//                   }),
//                   SizedBox(height: 50),
//                   Row(children: [
//                     SizedBox(width: 35),
//                     Text('Don\'t have an account? ',
//                         style:
//                             TextStyle(color: Colors.grey[500], fontSize: 20)),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => SignUpPage()));
//                       },
//                       child: Text('Create',
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold)),
//                     )
//                   ])
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ));
//   }
// }

import 'package:bloom/pages/signup.dart';
import 'package:bloom/pages/chat/pages/chatHome.dart';
import 'package:bloom/pages/period/pages/periodHome.dart';

import 'package:bloom/pages/chat/service/auth_service.dart';
import 'package:bloom/pages/chat/service/database_service.dart';
import 'package:bloom/pages/chat/helper/helper_function.dart';
import 'package:bloom/pages/chat/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bloom/pages/safetyAlert/pages/safetyAlertHome.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "Welcome!",
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text("Sign into your account",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400)),
                        Image.asset("assets/images/bloom_icon1.png"),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              labelText: "Email",
                              prefixIcon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                              )),
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },

                          // check tha validation
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!)
                                ? null
                                : "Please enter a valid email";
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                              labelText: "Password",
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Theme.of(context).primaryColor,
                              )),
                          validator: (val) {
                            if (val!.length < 6) {
                              return "Password must be at least 6 characters";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                //primary: Theme.of(context).primaryColor,
                                backgroundColor: Colors.red.shade300,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            child: const Text(
                              "Sign In",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () {
                              login();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                                text: "Register here",
                                style: const TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, const SignUpPage());
                                  }),
                          ],
                        )),
                      ],
                    )),
              ),
            ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUserNameandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          // saving the values to our shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
          nextScreenReplace(context, const SafetyAlertHomePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
