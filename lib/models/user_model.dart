import 'package:latlong2/latlong.dart';

class User {
  final String id;
  final String name;
  final String email;
  final DateTime? birthday;
  final List<dynamic> books;
  final List<dynamic> likedBooks;
  final List<dynamic> requests;
  final List<dynamic> followedUsers;
  final String? imageUrl; // Assuming you have a profile image URL
  final int? postCounts;
  final int? booksCounts;
  final int? followersCounts;
  final int? followingCounts;
  final LatLng? location;
  final String mobileNumber;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.birthday,
    required this.books,
    required this.likedBooks,
    required this.requests,
    required this.followedUsers,
    this.imageUrl,
    this.booksCounts,
    this.postCounts,
    this.followersCounts,
    this.followingCounts,
    this.location,
    required this.mobileNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    LatLng? parseLocation(Map<String, dynamic>? locationJson) {
      if (locationJson == null) {
        return null;
      }
      final latitude = locationJson['latitude'];
      final longitude = locationJson['longitude'];

      if (latitude != null && longitude != null) {
        return LatLng(latitude.toDouble(), longitude.toDouble());
      } else {
        return null;
      }
    }

    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      birthday:
          json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
      books: json['books'] != null ? List<dynamic>.from(json['books']) : [],
      likedBooks: json['likedBooks'] != null
          ? List<dynamic>.from(json['likedBooks'])
          : [],
      requests:
          json['requests'] != null ? List<dynamic>.from(json['requests']) : [],
      followedUsers: json['followedUsers'] != null
          ? List<dynamic>.from(json['followedUsers'])
          : [],
      imageUrl: json['imageUrl'],
      postCounts: json['postCount'],
      followersCounts: json['followersCount'],
      followingCounts: json['followingCount'],
      location: parseLocation(json['location']),
      mobileNumber: json['mobileNumber'] ?? '',
    );
  }
}
