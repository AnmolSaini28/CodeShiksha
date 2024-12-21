import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot> _getMessages() {
    return _firestore
        .collection('chat_rooms')
        .doc('general')
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    User? _user = FirebaseAuth.instance.currentUser;
    try {
      await _firestore
          .collection('chat_rooms')
          .doc('general')
          .collection('messages')
          .add({
        'text': _messageController.text.trim(),
        'sender': _user?.displayName,
        'senderId': _auth.currentUser?.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending message')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF161c28),
      appBar: AppBar(
        title: Text(
          'Chat Room',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Color(0xff171d28),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getMessages(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No messages yet',));
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var message = snapshot.data!.docs[index];
                      bool isCurrentUser =
                          message['senderId'] == _auth.currentUser?.uid;

                      return MessageBubble(
                        message: message['text'],
                        sender: message['sender'],
                        isCurrentUser: isCurrentUser,
                        timestamp: message['timestamp']?.toDate(),
                      );
                    },
                  );
                },
              ),
            ),
            // Message input
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16), // Maximize space usage
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, -2),
                    blurRadius: 4,
                    color: Colors.black12,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.blueAccent.withOpacity(0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 4), // Soft shadow for depth
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                decoration: InputDecoration(
                                  hintText: 'Type a message...',
                                  hintStyle: TextStyle(color: Colors.grey[500]),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                                ),
                                style: TextStyle(color: Colors.black87),
                                onSubmitted: (_) => _sendMessage(),
                              ),
                            ),
                            GestureDetector(
                              onTap: _sendMessage,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent, // Simple solid color button
                                  borderRadius: BorderRadius.circular(30), // Circle button
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueAccent.withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Message bubble widget for displaying individual messages
class MessageBubble extends StatelessWidget {
  final String message;
  final String sender;
  final bool isCurrentUser;
  final DateTime? timestamp;

  const MessageBubble({
    required this.message,
    required this.sender,
    required this.isCurrentUser,
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment:
        isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 4.0),
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: isCurrentUser ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    color: isCurrentUser ? Colors.white : Colors.black,
                  ),
                ),
                if (timestamp != null)
                  Text(
                    '${timestamp!.hour}:${timestamp!.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 10,
                      color: isCurrentUser ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
