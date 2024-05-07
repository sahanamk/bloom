import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:bloom/pages/safetyAlert/pages/emergencyContacts.dart';
import 'package:bloom/pages/chat/helper/helper_function.dart';
import 'package:bloom/pages/chat/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bloom/pages/chat/service/auth_service.dart';
import 'package:bloom/pages/chat/service/database_service.dart';
import 'package:bloom/pages/chat/pages/chatHome.dart';
import 'package:bloom/pages/period/pages/periodHome.dart';
import 'package:bloom/pages/profile.dart';
import 'package:bloom/pages/signin.dart';
import 'package:telephony/telephony.dart';

class SafetyAlertHomePage extends StatefulWidget {
  const SafetyAlertHomePage({super.key});

  @override
  State<SafetyAlertHomePage> createState() => _SafetyAlertHomePageState();
}

class _SafetyAlertHomePageState extends State<SafetyAlertHomePage> {
  final Telephony telephony = Telephony.instance;
  AuthService authService = AuthService();
  String userName = "";
  String email = "";
  String emergencyContact = "";
  String emergencyContactName = "";
  bool _isLoading = false;
  List<String> emergencyContacts = [];

  void initState() {
    super.initState();
    gettingUserData();
    _loadEmergencyContacts();
  }

  Future<void> _loadEmergencyContacts() async {
    try {
      emergencyContacts =
          await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .getEmergencyContacts();
      setState(() {}); // Update UI after successful data retrieval
    } catch (error) {
      print('Error fetching emergency contacts: $error');
      // Handle error appropriately (e.g., display error message)
    }
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, const EmergencyContactsPage());
              },
              icon: const Icon(
                Icons.contact_emergency_rounded,
              ))
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Safety Alert",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27),
        ),
      ),
      drawer: Drawer(
          child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: <Widget>[
          Icon(
            Icons.account_circle,
            size: 150,
            color: Colors.grey[700],
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            userName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 30,
          ),
          const Divider(
            height: 2,
          ),
          ListTile(
            onTap: () {
              nextScreenReplace(context, ChatHomePage());
            },
            selectedColor: Theme.of(context).primaryColor,
            selected: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),
            title: const Text(
              "Safety Alert",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () {
              nextScreenReplace(context, ChatHomePage());
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),
            title: const Text(
              "Groups",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () {
              nextScreenReplace(context, PeriodHomePage());
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),
            title: const Text(
              "Period Tracker",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () {
              nextScreenReplace(
                  context,
                  ProfilePage(
                    userName: userName,
                    email: email,
                  ));
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),
            title: const Text(
              "Profile",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () async {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await authService.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const SignInPage()),
                                (route) => false);
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    );
                  });
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.exit_to_app),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      )),
      body: Center(
        child: SizedBox(
            child: TextButton(
                child: Text(
                  "SOS",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 50),
                ),
                onPressed: () => _sendSMS(),
                style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 171, 18, 7),
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(0))),
            height: MediaQuery.sizeOf(context).height - 500,
            width: MediaQuery.sizeOf(context).width - 100),
      ),
      backgroundColor: const Color.fromARGB(255, 241, 207, 219),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: const Text(
                "Add an emergency contact",
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor),
                        )
                      : TextField(
                          onChanged: (val) {
                            setState(() {
                              if (val != null) emergencyContactName = val;
                            });
                          },
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: 'Name',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(20)),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(20)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                  SizedBox(height: 20),
                  TextField(
                    onChanged: (val) {
                      setState(() {
                        if (val.length == 10)
                          emergencyContact = val;
                        else
                          showSnackbar(
                              context, Colors.red, "Add correct phone number");
                      });
                    },
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        labelText: 'Phone Number',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20)),
                        errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(),
                  //primary: Theme.of(context).primaryColor),
                  child: const Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (emergencyContact != "") {
                      setState(() {
                        _isLoading = true;
                      });
                      DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .addEmergencyContact(
                              emergencyContactName, emergencyContact)
                          .whenComplete(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                      showSnackbar(context, Colors.green,
                          "Emergency contact added successfully.");
                    }
                  },
                  style: ElevatedButton.styleFrom(),
                  //primary: Theme.of(context).primaryColor),
                  child: const Text("ADD"),
                )
              ],
            );
          }));
        });
  }

  _sendSMS() async {
    print(emergencyContacts);
    if (emergencyContacts.isNotEmpty) {
      emergencyContacts.forEach((num) {
        telephony.sendSms(to: num, message: "HELP!");
      });
    } else {
      showSnackbar(context, Colors.red, "Add emergency contacts");
    }
  }

  // alertButton(BuildContext context) {
  //   @override
  //   Widget build(BuildContext context) {
  //     return Scaffold(
  //         body: Center(
  //       child: ElevatedButton(
  //         onPressed: () {
  //           // DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
  //           //     .sendAlertMessage(emergencyContacts);
  //         },
  //         child: Icon(
  //           Icons.circle,
  //           size: 100,
  //           color: Colors.red,
  //         ),
  //         style: ElevatedButton.styleFrom(
  //           shape: CircleBorder(),
  //           padding: EdgeInsets.all(0),
  //           elevation: 0,
  //         ),
  //       ),
  //     ));
  //   }
  // }
}
