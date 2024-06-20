import 'package:facebook/models/user_model.dart';

class Request {
  final String id;
  final String user;
  String status;

  Request({
    required this.id,
    required this.user,
    required this.status,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['_id'],
      user: json['user'],
      status: json['status'],
    );
  }
}
