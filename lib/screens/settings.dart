import 'package:facebook/config/palette.dart';
import 'package:facebook/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool nightMode = false;
  bool increaseFontSize = false;
  bool notificationsNewForYou = true;
  bool notificationsAccountActivity = true;
  bool notificationsNightMode = true;
  bool notificationsFontSize = true;
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController(); // Controller for birthday

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
          ),
        ),
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Row(
              children: [
                Icon(
                  Icons.person,
                  color: Palette.REDcolor,
                ),
                SizedBox(width: 8),
                Text(
                  "Account",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 15, thickness: 2),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                _showChangeNameDialog();
              },
              child: buildAccountOption("Change name"),
            ),
            GestureDetector(
              onTap: () {
                _showChangePasswordDialog();
              },
              child: buildAccountOption("Change password"),
            ),
            GestureDetector(
              onTap: () {
                _showChangeBirthdayDialog();
              },
              child: buildAccountOption("Change Birthday"),
            ),
            GestureDetector(
              onTap: () {
                // Handle Language action
              },
              child: buildAccountOption("Language"),
            ),
            GestureDetector(
              onTap: () {
                // Handle Privacy and Security action
              },
              child: buildAccountOption("Privacy and security"),
            ),
            const SizedBox(height: 40),
            const Row(
              children: [
                Icon(
                  Icons.volume_up_outlined,
                  color: Palette.REDcolor,
                ),
                SizedBox(width: 8),
                Text(
                  "Notifications",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 15, thickness: 2),
            const SizedBox(height: 10),
            buildNotificationOptionRow("New for you", notificationsNewForYou),
            buildNotificationOptionRow(
                "Account activity", notificationsAccountActivity),
            const SizedBox(height: 40),
            const Text(
              'Reading Preferences',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 30.0, thickness: 2.0),
            buildNotificationOptionRow("Night Mode", notificationsNightMode),
            buildNotificationOptionRow(
                "Increase Font Size", notificationsFontSize),
            const SizedBox(height: 40.0),
            const Text(
              'Library Management',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 30.0, thickness: 2.0),
            ListTile(
              title: const Text('Manage Bookmarks'),
              leading: const Icon(Icons.bookmark),
              onTap: () {
                // Navigate to bookmark management screen
              },
            ),
            ListTile(
              title: const Text('Clear Cache'),
              leading: const Icon(Icons.delete),
              onTap: () {
                // Prompt user to clear cache
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAccountOption(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]),
        ),
        Transform.scale(
          scale: 0.7,
          child: CupertinoSwitch(
            value: isActive,
            onChanged: (bool val) {
              setState(() {
                if (title == "New for you") {
                  notificationsNewForYou = val;
                } else if (title == "Account activity") {
                  notificationsAccountActivity = val;
                } else if (title == "Night Mode") {
                  notificationsNightMode = val;
                } else if (title == "Increase Font Size") {
                  notificationsFontSize = val;
                }
              });
              // Handle notification setting change
            },
          ),
        ),
      ],
    );
  }

  void _showChangeNameDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Name'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: 'Enter new name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _updateName();
              Navigator.of(context).pop();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateName() async {
    final newName = _nameController.text;
    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name cannot be empty')),
      );
      return;
    }

    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      if (user != null) {
        print('Updating name for user: ${user.name}');
        print('New name: $newName');

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .update({
          'name': newName,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Name updated successfully!')),
        );
        print('Name updated successfully in Firestore');
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      print('Error updating name: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update name: $e')),
      );
    }
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _oldPasswordController,
              decoration: const InputDecoration(
                hintText: 'Enter old password',
              ),
              obscureText: true,
            ),
            TextField(
              controller: _newPasswordController,
              decoration: const InputDecoration(
                hintText: 'Enter new password',
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _updatePassword();
              Navigator.of(context).pop();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _updatePassword() async {
    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;

    if (oldPassword.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Both fields are required')),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPassword,
        );

        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully!')),
        );

        // Clear text fields after successful update
        _oldPasswordController.clear();
        _newPasswordController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is currently signed in')),
        );
      }
    } catch (e) {
      print('Error updating password: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update password: $e')),
      );
    }
  }

  void _showChangeBirthdayDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Birthday'),
        content: TextField(
          controller: _dobController,
          readOnly: true, // make it readonly
          decoration: const InputDecoration(
            hintText: 'Select Date of Birth',
            suffixIcon: Icon(Icons.calendar_today),
          ),
          onTap: () {
            _selectDate(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _updateBirthday();
              Navigator.of(context).pop();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

  Future<void> _updateBirthday() async {
    final newBirthday = _dobController.text;
    if (newBirthday.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Birthday cannot be empty')),
      );
      return;
    }

    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      if (user != null) {
        print('Updating birthday for user: ${user.name}');
        print('New birthday: $newBirthday');

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .update({
          'birthday': newBirthday,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Birthday updated successfully!')),
        );
        print('Birthday updated successfully in Firestore');
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      print('Error updating birthday: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update birthday: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _dobController.dispose();
    super.dispose();
  }
}
