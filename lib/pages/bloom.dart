import 'package:bloom/pages/signin.dart';
import 'package:flutter/material.dart';
import 'package:bloom/reusable_widgets/reusable_widget.dart';
import 'dart:async';
//import 'package:google_fonts/google_fonts.dart';

class BloomPage extends StatefulWidget {
  const BloomPage({super.key});

  @override
  State<BloomPage> createState() => _BloomPageState();
}

class _BloomPageState extends State<BloomPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        const Duration(seconds: 5),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const SignInPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        // decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //   begin: Alignment.topRight,
        //   end: Alignment.bottomLeft,
        //   stops: [
        //     0.1,
        //     0.4,
        //     0.6,
        //     0.9,
        //   ],
        //   colors: [
        //     Colors.yellow,
        //     Colors.red,
        //     Colors.indigo,
        //     Colors.teal,
        //   ],
        // )),
        child: Stack(children: <Widget>[
          Align(
            alignment: Alignment(0.0, 0.2),
            child: Text(
              'bloom',
              style: TextStyle(
                fontFamily: 'Voga',
                fontSize: 75.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Align(
              alignment: Alignment(0.0, -0.2),
              child: logoWidget('assets/images/bloom_icon1.png'))
        ]),
      )),
    );
  }
}
