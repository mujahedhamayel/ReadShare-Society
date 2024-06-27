import 'package:cached_network_image/cached_network_image.dart';
import 'package:facebook/constants.dart';
import 'package:facebook/utils/api_util.dart';
import 'package:facebook/utils/auth_token.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/followed_user_provider.dart';
import '../providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class DiscussionRoomPage extends StatefulWidget {
  @override
  _DiscussionRoomPageState createState() => _DiscussionRoomPageState();
}

class _DiscussionRoomPageState extends State<DiscussionRoomPage> {
  final TextEditingController _zoomLinkController = TextEditingController();
    final TextEditingController _topicController = TextEditingController(); 

  List<User> _selectedUsers = [];
  List<DiscussionRoom> _discussionRooms = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchDiscussionRooms();
  }

  Future<void> _createDiscussionRoom() async {
    setState(() {
      _isLoading = true;
    });

    final url = 'http://$ip:$port/api/discussionRooms/create';

    String token = AuthToken().getToken;

    final response = await http.post(
      Uri.parse(url),
      headers: ApiUtil.headers(token),
      body: jsonEncode({
        'participants': _selectedUsers.map((user) => user.id).toList(),
        'zoomLink': _zoomLinkController.text,
        'topic': _topicController.text,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Discussion Room Created')));
      _zoomLinkController.clear();
      setState(() {
        _selectedUsers = [];
      });
      _fetchDiscussionRooms(); // Refresh the list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create Discussion Room')));
    }
  }

  Future<void> _fetchDiscussionRooms() async {
    setState(() {
      _isLoading = true;
    });

    final url = 'http://$ip:$port/api/discussionRooms';
    String token = AuthToken().getToken;

    final response = await http.get(
      Uri.parse(url),
      headers: ApiUtil.headers(token),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);
      setState(() {
        _discussionRooms =
            json.map((room) => DiscussionRoom.fromJson(room)).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch Discussion Rooms')));
    }
  }

   Future<void> _deleteDiscussionRoom(String roomId) async {
    try {
      final url = 'http://$ip:$port/api/discussionRooms/$roomId';
      String token = AuthToken().getToken;

      final response = await http.delete(
        Uri.parse(url),
        headers: ApiUtil.headers(token),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Discussion Room Deleted')));
        await _fetchDiscussionRooms(); // Refresh the list
      } else {
        print('Failed to delete discussion room: ${response.body}');

        throw Exception('Failed to delete Discussion Room');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _removeParticipant(String roomId) async {
    try {
      final url = 'http://$ip:$port/api/discussionRooms/$roomId/removeParticipant';
      String token = AuthToken().getToken;
      final response = await http.post(
        Uri.parse(url),
        headers: ApiUtil.headers(token),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You have left the room')));
        await _fetchDiscussionRooms(); // Refresh the list
      } else {
        throw Exception('Failed to leave Discussion Room');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
String formatDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    return DateFormat('MM-dd HH:mm').format(dateTime);
  }


  void _joinZoomMeeting(String zoomLink) async {
    final uri = Uri.parse(zoomLink);
    print("Attempting to launch: $uri"); // Add this line for debugging
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode
            .externalApplication, // Ensure the link opens in an external browser
      );
    } else {
      print("Could not launch: $uri");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not launch $zoomLink')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final followedUsers = Provider.of<FollowedUsersProvider>(context).followedUsers;
    final currentUser = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Discussion Room'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _zoomLinkController,
                    decoration: InputDecoration(
                      labelText: 'Zoom Link',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _topicController,
                    decoration: InputDecoration(
                      labelText: 'Discussion Topic',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Select Users:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: followedUsers.length,
                      itemBuilder: (context, index) {
                        final user = followedUsers[index];
                        return CheckboxListTile(
                          secondary: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(user.imageUrl ?? ''),
                          ),
                          title: Text(user.name),
                          value: _selectedUsers.contains(user),
                          onChanged: (isSelected) {
                            setState(() {
                              if (isSelected!) {
                                _selectedUsers.add(user);
                              } else {
                                _selectedUsers.remove(user);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _selectedUsers.map((user) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(user.imageUrl ?? ''),
                                radius: 30,
                              ),
                              SizedBox(height: 5),
                              Text(user.name, style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _createDiscussionRoom,
                    child: Text('Create Discussion Room'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Your Discussion Rooms:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _discussionRooms.length,
                      itemBuilder: (context, index) {
                        final room = _discussionRooms[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            // leading: CircleAvatar(
                            //   backgroundImage: CachedNetworkImageProvider(room.creator.imageUrl ?? ''),
                            // ),
                            title: Text('Room created by ${room.creator.name}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Topic: ${room.topic}'),
                                Text('Participants: ${room.participants.length}'),
                                Text('Created at:${formatDate(room.createdAt.toString())}'),
                              ],
                            ),
                            trailing: Wrap(
                              spacing: 12,
                              children: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    _joinZoomMeeting(room.zoomLink);
                                  },
                                  child: Text('Join'),
                                ),
                                if (room.creator.id == currentUser?.id)
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      _deleteDiscussionRoom(room.id);
                                    },
                                  ),
                                if (room.creator.id != currentUser?.id)
                                  ElevatedButton(
                                    onPressed: () {
                                      _removeParticipant(room.id);
                                    },
                                    child: Text('Deny'),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
class DiscussionRoom {
  final String id;
  final User creator;
  final List<User> participants;
  final String zoomLink;
  final String topic;
  final DateTime createdAt;

  DiscussionRoom({required this.id, required this.creator, required this.participants, required this.zoomLink, required this.topic, required this.createdAt});

  factory DiscussionRoom.fromJson(Map<String, dynamic> json) {
    return DiscussionRoom(
      id: json['_id'],
      creator: User.fromJson(json['creator']),
      participants: (json['participants'] as List).map((i) => User.fromJson(i)).toList(),
      zoomLink: json['zoomLink'],
      topic: json['topic'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}