import 'package:flutter/material.dart';
import '../config/palette.dart';
import '../models/user_model.dart';
import '../widgets/user_card.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'Chat',
          style: TextStyle(
            color: Palette.REDcolor,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.2,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20), // Add padding to the entire list
        itemCount: userList.length,
        itemBuilder: (context, index) {
          final user = userList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 16), // Add vertical padding here
            child: UserCardChat(user: user), // Use UserCardChat here
          ); // Use UserCardChat here
        },
      ),
    );
  }
}

final List<User> userList = [
  const User(
      name: 'John',
      id: '1',
      email: '',
      books: [],
      likedBooks: [],
      requests: [],
      followedUsers: []),
  const User(
      name: 'Bob',
      id: '2',
      email: '',
      books: [],
      likedBooks: [],
      requests: [],
      followedUsers: []),
  const User(
      name: 'Mays',
      id: '3',
      email: '',
      books: [],
      likedBooks: [],
      requests: [],
      followedUsers: []),
  // Add more users as needed
];

class Chatscreen extends StatefulWidget {
  final User user;
  const Chatscreen({super.key, required this.user});

  @override
  _ChatscreentState createState() => _ChatscreentState();
}

class _ChatscreentState extends State<Chatscreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<MessageBubble> _messages = [];

  @override
  Widget build(BuildContext context) {
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
            MessagesStream(
              messages: _messages,
              user: widget.user, // Pass the messages list to MessagesStream
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Palette.REDcolor, // Changed color to red
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
                        fillColor: Palette.REDcolor, // Changed color to red
                        elevation: 0.0,
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          final messageText = _messageController.text.trim();
                          if (messageText.isNotEmpty) {
                            setState(() {
                              _messages.add(MessageBubble(
                                sender: 'You',
                                text:
                                    messageText, // Display the entered message
                                isMe: true,
                              ));
                            });
                            _messageController.clear();
                          }
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

class MessagesStream extends StatelessWidget {
  final User user;
  final List<MessageBubble> messages;
  const MessagesStream({Key? key, required this.user, required this.messages})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: /* messages.isEmpty
            ? Center(
                child: Text(
                  "Start the conversation!",
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
              )
            : */
            ListView.builder(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 10.0,
          ),
          itemCount: messages.length + 1, // Add 1 for default message
          itemBuilder: (context, index) {
            if (index == 0) {
              // Render default message
              return MessageBubble(
                sender: user.name,
                text: "Hello!",
                isMe: false,
              );
            } else {
              // Render actual messages
              final message = messages[index - 1];
              return message;
            }
          },
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
