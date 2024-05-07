// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// class ChatWindowPage extends StatefulWidget {
//   const ChatWindowPage({super.key});

//   @override
//   State<ChatWindowPage> createState() => _ChatWindowPageState();
// }

// class _ChatWindowPageState extends State<ChatWindowPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF553370),
//       body: Container(
//         margin: EdgeInsets.only(top: 50, left: 20, right: 20),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 10),
//               child: Row(
//                 children: [
//                   Icon(Icons.arrow_back_ios_outlined, color: Color(0xffc199cd)),
//                   SizedBox(
//                     width: 90,
//                   ),
//                   Text("Sahana M K",
//                       style: TextStyle(
//                           color: Color(0xffc199cd),
//                           fontSize: 20,
//                           fontWeight: FontWeight.w500))
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//             Container(
//               padding:
//                   EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 40),
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height / 1.15,
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30))),
//               child: Column(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(10),
//                     margin: EdgeInsets.only(
//                         left: MediaQuery.of(context).size.width / 2),
//                     alignment: Alignment.bottomRight,
//                     decoration: BoxDecoration(
//                         color: Color(0xFFfafbfd),
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10),
//                             bottomLeft: Radius.circular(10))),
//                     child: Text(
//                       "Hello",
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Container(
//                     padding: EdgeInsets.all(10),
//                     margin: EdgeInsets.only(
//                         right: MediaQuery.of(context).size.width / 2),
//                     alignment: Alignment.bottomRight,
//                     decoration: BoxDecoration(
//                         color: Color(0xFFeaf4fd),
//                         borderRadius: BorderRadius.only(
//                             bottomRight: Radius.circular(10),
//                             topRight: Radius.circular(10),
//                             topLeft: Radius.circular(10))),
//                     child: Text(
//                       "Hello",
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                   Spacer(),
//                   Material(
//                     elevation: 5,
//                     borderRadius: BorderRadius.circular(20),
//                     child: Container(
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Row(
//                         children: [
//                           Expanded(
//                               child: TextField(
//                             decoration: InputDecoration(
//                                 border: InputBorder.none,
//                                 hintText: "Type a message"),
//                           ))
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
