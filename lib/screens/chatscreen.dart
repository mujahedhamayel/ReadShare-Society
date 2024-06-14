import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook/constants.dart';
import 'package:facebook/providers/followed_user_provider.dart';
import 'package:facebook/providers/user_provider.dart';
import 'package:facebook/services/user_service.dart';
import 'package:facebook/utils/api_util.dart';
import 'package:facebook/utils/auth_token.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/palette.dart';
import '../models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Chatscreen extends StatefulWidget {
  final User user;
  final String defaultMessage; // Add this line

  const Chatscreen({Key? key, required this.user, required this.defaultMessage})
      : super(key: key); // Update the constructor

  @override
  _ChatscreenState createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _messageController.text = widget.defaultMessage; // Set the default message
  }

  void _sendMessage(User loggedInUser) async {
    if (_messageController.text.isNotEmpty) {
      await _firestore
          .collection('chats')
          .doc(getChatId(loggedInUser.id, widget.user.id))
          .collection('messages')
          .add({
        'text': _messageController.text,
        'senderId': loggedInUser.id, // Replace with logged in user ID
        'receiverId': widget.user.id,
        'senderName': loggedInUser.name, // Replace with logged in user ID
        'receiverName': widget.user.name,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((_) async {
        // #TODO:send message notificatopn
        final String apiUrl = 'http://$ip:$port/api/notification';
        String token = AuthToken().getToken;

        final url = '$apiUrl/chat/${widget.user.id}/${_messageController.text}';

        final response = await http.post(
          Uri.parse(url),
          headers: ApiUtil.headers(token),
        );

        if (response.statusCode != 200) {
          throw Exception('message  notification not sent');
        }
        if (widget.defaultMessage != '') {
          await UserService().addChattedUser(widget.user.id);
        } // cahtgpt do it here
        // Add user to followed list if not already followed
        final followedUsersProvider =
            Provider.of<FollowedUsersProvider>(context, listen: false);
        if (!followedUsersProvider.followedUsers
            .any((user) => user.id == widget.user.id)) {
          followedUsersProvider.addFollowedUser(widget.user);
        }
      }); //here
      _messageController.clear();
    }
  }

  String getChatId(String userId1, String userId2) {
    // Ensure the IDs are always concatenated in the same order
    return userId1.hashCode <= userId2.hashCode
        ? '${userId1}_$userId2'
        : '${userId2}_$userId1';
  }

  @override
  Widget build(BuildContext context) {
    final providerUser = Provider.of<UserProvider>(context, listen: false).user;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: Text(
          widget.user.name, // Display the selected user's name
          style: const TextStyle(
            color: Palette.REDcolor,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.2,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chats')
                    .doc(getChatId(providerUser!.id, widget.user.id))
                    .collection('messages')
                    .orderBy('timestamp')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final messages = snapshot.data!.docs.reversed;
                  List<MessageBubble> messageBubbles = [];
                  for (var message in messages) {
                    final messageText = message['text'];
                    final messageSenderName = message['senderName'];
                    final messageSenderId = message['senderId'];

                    final messageBubble = MessageBubble(
                      sender: messageSenderName,
                      text: messageText,
                      isMe: providerUser.id == messageSenderId,
                    );
                    messageBubbles.add(messageBubble);
                  }
                  return ListView(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                    children: messageBubbles,
                  );
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Palette.REDcolor,
                    width: 1.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(
                        16.0,
                        12.0,
                        8.0,
                        16.0,
                      ),
                      child: TextFormField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type message..',
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(
                        8.0,
                        12.0,
                        16.0,
                        16.0,
                      ),
                      child: RawMaterialButton(
                        padding: const EdgeInsets.all(12.0),
                        fillColor: Palette.REDcolor,
                        elevation: 0.0,
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _sendMessage(providerUser);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  const MessageBubble({
    required this.sender,
    required this.text,
    required this.isMe,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black54,
            ),
          ),
          const SizedBox(
            height: 4.0,
          ),
          Material(
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  )
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
            elevation: 0.0,
            color: isMe ? Palette.REDcolor : Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 24.0,
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
