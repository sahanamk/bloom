import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_sms/flutter_sms.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  // Future<void> sendEmergencyAlert() async {
  //   try {
  //     // Get FCM token
  //     String? fcmToken = await FirebaseMessaging.instance.getToken();

  //     // Send notification to emergency contacts
  //     await userCollection.doc(uid).collection('emergencyContacts').get()
  //         .then((querySnapshot) {
  //       querySnapshot.docs.forEach((doc) async {
  //         String? contactFcmToken = doc['fcm_token'];
  //         if (contactFcmToken != null) {
  //           await FirebaseMessaging.instance.send(
  //             RemoteMessage(
  //               to: contactFcmToken,
  //               data: {
  //                 'title': 'Emergency Alert',
  //                 'body': 'Emergency situation, please respond!',
  //               },
  //             ),
  //           );
  //         }
  //       });
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Emergency alert sent')),
  //     );
  //   } catch (e) {
  //     print("Error sending emergency alert: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to send emergency alert')),
  //     );
  //   }
  // }

  Future addPeriodData(DateTime startDate, DateTime endDate) async {
    try {
      //int durationInDays = endDate.difference(startDate).inDays;
      userCollection.doc(uid).collection("period").add({
        'start_date': startDate,
        'end_date': endDate,
        //'duration_days': durationInDays,
      });
    } catch (e) {
      log("Error adding period data: $e");
    }
  }

  Future addEmergencyContact(
      String emergencyContactName, String emergencyContact) async {
    try {
      //int durationInDays = endDate.difference(startDate).inDays;
      userCollection.doc(uid).collection("emergencyContacts").add({
        'name': emergencyContactName,
        'phone_no': emergencyContact,
        //'duration_days': durationInDays,
      });
    } catch (e) {
      log("Error adding emergency contact: $e");
    }
  }

  Future<List<String>> getEmergencyContacts() async {
    List<String> emergencyContactList = [];
    try {
      // Query period data from the "period" subcollection
      QuerySnapshot contactsSnapshot =
          await userCollection.doc(uid).collection('emergencyContacts').get();

      // Extract period data from the documents
      if (contactsSnapshot.docs.isNotEmpty) {
        // Get the start date closest to the present date
        contactsSnapshot.docs.forEach((doc) {
          emergencyContactList.add(doc['phone_no']);
        });
      }
    } catch (e) {
      print("Error retrieving period data: $e");
    }

    return emergencyContactList;
  }

  Future<List<Map<String, dynamic>>> getEmergencyDetails() async {
    List<Map<String, dynamic>> emergencyDetails = [];
    try {
      // Query period data from the "period" subcollection
      QuerySnapshot contactsSnapshot =
          await userCollection.doc(uid).collection('emergencyContacts').get();

      // Extract period data from the documents
      contactsSnapshot.docs.forEach((doc) {
        // Get the start date closest to the present date
        Map<String, dynamic> emergencyContact = {
          'name': doc['name'],
          'phone_no': doc['phone_no'],
        };
        emergencyDetails.add(emergencyContact);
      });
    } catch (e) {
      print("Error retrieving period data: $e");
    }
    return emergencyDetails;
  }

  Future<void> deleteEmergencyContact(String phoneNumber) async {
    try {
      // Query the emergencyContacts collection for documents with the specified phone number
      QuerySnapshot querySnapshot = await userCollection
          .doc(uid)
          .collection("emergencyContacts")
          .where('phone_no', isEqualTo: phoneNumber)
          .get();

      // Iterate through the documents found and delete each one
      for (DocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print("Error deleting emergency contact: $e");
      // Handle error appropriately
    }
  }
  // void sendAlertMessage(List<String> emergencyContactList) async {
  //   String result =
  //       await sendSMS(message: "alert", recipients: emergencyContactList)
  //           .catchError((onError) {
  //     print(onError);
  //   });
  //   print(result);
  // }

  Future<List<DateTime>> getPeriodData() async {
    List<DateTime> periodDataList = [];

    try {
      // Query period data from the "period" subcollection
      QuerySnapshot periodSnapshot =
          await userCollection.doc(uid).collection('period').get();

      // Extract period data from the documents
      periodSnapshot.docs.forEach((doc) {
        DateTime startDate = doc['start_date'].toDate();
        DateTime endDate = doc['end_date'].toDate();

        // Add each date within the period range to the list
        for (DateTime date = startDate;
            date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
            date = date.add(Duration(days: 1))) {
          periodDataList.add(date);
        }
      });
    } catch (e) {
      print("Error retrieving period data: $e");
    }

    return periodDataList;
  }

  Future<DateTime> getLatestStartDate() async {
    dynamic latestStartDate;
    try {
      // Query period data from the "period" subcollection
      QuerySnapshot periodSnapshot = await userCollection
          .doc(uid)
          .collection('period')
          .orderBy('start_date', descending: false)
          .get();

      // Extract period data from the documents
      if (periodSnapshot.docs.isNotEmpty) {
        // Get the start date closest to the present date
        latestStartDate = periodSnapshot.docs.first['start_date'].toDate();
      }
    } catch (e) {
      print("Error retrieving period data: $e");
    }
    return latestStartDate;
  }

  // saving the userdata
  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  // creating a group
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

    // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  // getting the chats
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // get group members
  getGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  // search
  searchByName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  // function -> bool
  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  // toggling the group join/exit
  Future toggleGroupJoin(
      String groupId, String userName, String groupName) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part re join
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  // send message
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }
}
