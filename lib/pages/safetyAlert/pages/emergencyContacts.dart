import 'package:flutter/material.dart';
import 'package:bloom/pages/chat/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmergencyContactsPage extends StatefulWidget {
  const EmergencyContactsPage({super.key});

  @override
  State<EmergencyContactsPage> createState() => _EmergencyContactsPageState();
}

class _EmergencyContactsPageState extends State<EmergencyContactsPage> {
  List<Map<String, dynamic>> emergencyDetails = [];

  @override
  void initState() {
    super.initState();
    _loadEmergencyDetails();
  }

  Future<void> _loadEmergencyDetails() async {
    try {
      emergencyDetails =
          await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .getEmergencyDetails();
      setState(() {}); // Update UI after successful data retrieval
    } catch (error) {
      print('Error fetching emergency contact details: $error');
      // Handle error appropriately (e.g., display error message)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Emergency Contacts",
          style: TextStyle(
              fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: emergencyDetails.length,
        itemBuilder: (context, index) {
          String contactName = emergencyDetails[index]['name'] ?? 'Unknown';
          String phoneNumber = emergencyDetails[index]['phone_no'] ?? 'Unknown';
          return ListTile(
            title: Text(contactName),
            subtitle: Text(phoneNumber),
            leading: Icon(Icons.person),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                    .deleteEmergencyContact(phoneNumber);
                // Implement delete functionality here
                // You can call a method to delete the contact from the database
                setState(() {
                  // Update emergencyDetails list after deletion
                  emergencyDetails.removeAt(index);
                });
              },
            ),
          );
        },
      ),
    );
  }
}
