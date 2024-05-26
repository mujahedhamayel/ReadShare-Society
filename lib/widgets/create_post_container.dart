import 'package:facebook/helpers/auth_token.dart';
import 'package:facebook/screens/ProfilePage.dart';

import 'package:flutter/material.dart';
import '/models/models.dart';
import '/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/models/models.dart';

import 'package:path/path.dart' as path;
import 'package:facebook/constants.dart';
import 'package:facebook/models/user_model.dart';
import 'package:facebook/widgets/profile_avatar.dart';
import '/config/palette.dart';



class CreatePostContainer extends StatefulWidget {
  final User currentUser;

  const CreatePostContainer({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  _CreatePostContainerState createState() => _CreatePostContainerState();
}

class _CreatePostContainerState extends State<CreatePostContainer> {
  final TextEditingController _textController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<String> _uploadImage(File file) async {
    String fileName = path.basename(file.path);
    Reference storageReference = FirebaseStorage.instance.ref().child('posts/$fileName');
    UploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.whenComplete(() => null);
    String returnURL = await storageReference.getDownloadURL();
    return returnURL;
  }

  Future<void> _createPost() async {
    String? imageUrl;
    if (_imageFile != null) {
      imageUrl = await _uploadImage(_imageFile!);
    }
    await _storePost(imageUrl);
  }

  Future<void> _storePost(String? imageUrl) async {
    print('imageUrl');
    print(imageUrl);
    String? token = AuthToken().getToken;
    final response = await http.post(
      Uri.parse('http://$ip:$port/api/posts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'description': _textController.text,
        'imagepost': imageUrl,
      }),
    );

    if (response.statusCode == 201) {
      print('Post created successfully');
    } else {
      throw Exception('Failed to create post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                ProfileAvatar(
                  user: widget.currentUser,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration.collapsed(
                      hintText: 'What did you read today?',
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 10.0, thickness: 0.5),
            SizedBox(
              height: 40.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(
                      Icons.photo_library,
                      color: Colors.green,
                    ),
                    label: const Text('Photo'),
                  ),
                ],
              ),
            ),
            if (_imageFile != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Image.file(_imageFile!),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: _createPost,
                  child: const Text(
                    'Post',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}