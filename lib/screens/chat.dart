import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/screens/settings_screen.dart';
import 'package:chat_app/widgets/chat_messages.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key); // Removed const

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _selectedIndex = 0; // New state variable for bottom navigation index

  void setupPushNotification() async {
    final fcm = FirebaseMessaging.instance;
    NotificationSettings settings = await fcm.requestPermission();
    print('User push notification status: ${settings.authorizationStatus}');

    String? token = await fcm.getToken();
    print('FCM Token: $token');

    // TODO: You may want to send the token to your server for push notification purposes
  }

  @override
  void initState() {
    super.initState();
    setupPushNotification();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 1:
        return ProfileScreen(); // Removed const
      case 2:
        return SettingsScreen(); // Removed const
      default:
        return Column(
          children: <Widget>[
            Expanded(
              child: ChatMessages(),
            ),
            NewMessage(),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'), // Removed const
        backgroundColor: Color(0xFFFEB81C), // Set the AppBar color
      ),
      body: _getScreen(_selectedIndex), // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: Colors.white),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.white),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Color(0xFFFEB81C),
        onTap: _onItemTapped,
        selectedItemColor: Colors.white, // Added for selected item color
      ),
    );
  }
}
