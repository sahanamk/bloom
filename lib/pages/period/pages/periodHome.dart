import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bloom/pages/period/pages/periodCalender.dart';
import 'package:bloom/pages/chat/widgets/widgets.dart';
import 'package:bloom/pages/chat/helper/helper_function.dart';
import 'package:bloom/pages/chat/service/auth_service.dart';
import 'package:bloom/pages/signin.dart';
import 'package:bloom/pages/profile.dart';
import 'package:bloom/pages/chat/pages/chatHome.dart';
import 'package:bloom/pages/safetyAlert/pages/safetyAlertHome.dart';
import 'package:bloom/pages/chat/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PeriodHomePage extends StatefulWidget {
  //final String userId;
  const PeriodHomePage(
      {
      //required this.userId,
      super.key});

  @override
  State<PeriodHomePage> createState() => _PeriodHomePageState();
}

class _PeriodHomePageState extends State<PeriodHomePage> {
  AuthService authService = AuthService();
  String userName = "";
  String email = "";
  late dynamic latestStartDate;
  late dynamic nextOvulationDate;
  late dynamic nextPeriodDate;

  // final TextEditingController startDateController = TextEditingController();
  // final TextEditingController endDateController = TextEditingController();

  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    gettingUserData();
    _startDate = DateTime.now();
    _endDate = DateTime.now();
    _loadStartDates();
    latestStartDate = null;
    nextOvulationDate = null;
    nextPeriodDate = null;
  }

  Future<void> _loadStartDates() async {
    try {
      latestStartDate =
          await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .getLatestStartDate();
      if (latestStartDate != null) {
        nextOvulationDate = latestStartDate.add(Duration(days: 14));
        nextPeriodDate = latestStartDate.add(Duration(days: 28));
      }
      setState(() {}); // Update UI after successful data retrieval
    } catch (error) {
      print('Error fetching period data: $error');
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
                nextScreen(context, const PeriodCalenderPage());
              },
              icon: const Icon(
                Icons.calendar_month_outlined,
              ))
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Period Tracker",
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
              nextScreenReplace(context, SafetyAlertHomePage());
            },
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
            onTap: () {},
            selectedColor: Theme.of(context).primaryColor,
            selected: true,
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
      body: periodTracker(context),
      backgroundColor: const Color.fromARGB(255, 241, 207, 219),
    );
  }

  periodTracker(BuildContext context) {
    return Stack(children: [
      Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/pinkDrop.png"),
                  fit: BoxFit.contain))),
      Padding(
        padding: const EdgeInsets.only(left: 100, right: 100, top: 450),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                //primary: Theme.of(context).primaryColor,
                backgroundColor: Colors.red.shade300,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
            child: const Text(
              "Log Period",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onPressed: () {
              addPeriodDialog(context);
            },
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 150, right: 100, top: 300),
        child: SizedBox(
            width: MediaQuery.of(context).size.width - 200,
            child: getNextPeriodText(nextPeriodDate)),
      ),
    ]);
  }

  Widget getNextPeriodText(DateTime? nextPeriodDate) {
    if (nextPeriodDate == null) {
      return Text('No period\n date available',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 194, 29, 29),
              fontSize: 20));
    } else {
      DateTime now = DateTime.now();
      Duration difference = nextPeriodDate.difference(now);
      int remainingDays = difference.inDays;

      if (remainingDays > 0) {
        return Text(' Period starts\n in $remainingDays days',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 194, 29, 292),
                fontSize: 20));
      } else if (remainingDays == 0) {
        return Text('Period may\n start today',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 194, 29, 29),
                fontSize: 20));
      } else {
        return Text('Period date\n has passed',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 194, 29, 29),
                fontSize: 20));
      }
    }
  }

  addPeriodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log Period'),
          content: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Start Date:',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _startDate) {
                        setState(() {
                          _startDate = picked;
                        });
                      }
                    },
                    child: Text('Select Start Date'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'End Date:',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _endDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _endDate) {
                        setState(() {
                          _endDate = picked;
                        });
                      }
                    },
                    child: Text('Select End Date'),
                  ),
                  SizedBox(height: 16),
                ],
              )),
          actions: [
            ElevatedButton(
              onPressed: () async {
                DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                    .addPeriodData(_startDate, _endDate);

                // List<DateTime> periodDataList = await DatabaseService(
                //         uid: FirebaseAuth.instance.currentUser!.uid)
                //     .getPeriodData();

                // periodDataList.forEach((date) {
                //   print('Period Date: $date');
                // });

                Navigator.pop(context);
              },
              child: Text("Log Period"),
            ),
          ],
        );
      },
    );
  }
}
