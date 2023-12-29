import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'message_bubble.dart';

class ChatMessages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final chatDocs = chatSnapshot.data?.docs ?? [];

        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) {
            var messageData = chatDocs[index].data() as Map<String, dynamic>;
            String userName =
                messageData['username'] ?? ''; // Corrected field name
            String userImage =
                messageData['imageUrl'] ?? ''; // Corrected field name

            // Removed the const keyword as userName and userImage are runtime values
            return MessageBubble(
              userName: userName,
              userImage: userImage,
              message: messageData['text'] ?? '',
              isMe: messageData['userId'] == user?.uid,
              key: ValueKey(chatDocs[index].id),
            );
          },
        );
      },
    );
  }
}
