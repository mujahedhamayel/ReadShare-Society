import 'package:facebook/models/request_model.dart';

class Book {
  String type;
  String title;
  String owner;
  DateTime updateDate;
  String imgUrl;
  String author;
  String? location;
  num rate;
  List<Review> review;
  String id;
  List<String> likes;
  String? pdfLink;
  double? userRating;
  num price;
  List<Request> requests;

  // num height;

  Book(
    this.type,
    this.title,
    this.owner,
    this.updateDate,
    this.imgUrl,
    this.author,
    this.location,
    this.rate,
    this.review,
    this.id,
    this.likes,
    this.pdfLink,
    this.userRating,
    this.price,
    this.requests,
    // this.height,
  );

  
  factory Book.fromJson(Map<String, dynamic> json) {
    List<Review> reviewList = json.containsKey('reviews')
        ? (json['reviews'] as List)
            .map((reviewJson) => Review.fromJson(reviewJson))
            .toList()
        : [];

    var likesList = json.containsKey('likes')
        ? (json['likes'] as List<dynamic>)
            .map((like) => like as String)
            .toList()
        : [];

    var requestList = (json['requests'] as List?)
            ?.map((requestJson) => Request.fromJson(requestJson))
            .toList() ??
        [];

    return Book(
      json['type'],
      json['title'],
      json['owner'] ??
          {}, 
      DateTime.parse(json['updatedAt']),
      json['image'],
      json['author'],
      json['location'],
      json['rate'] ?? 0.0,
      reviewList,
      json['_id'],
      likesList as List<String>,
      json['pdfLink'],
      json['userRating']?.toDouble(),
      json['price'],
      requestList,
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'owner': owner,
      'updatedAt': updateDate.toIso8601String(),
      'image': imgUrl,
      'author': author,
      'location': location,
      'rate': rate,
      '_id': id,
      'likes': likes,
      'pdfLink': pdfLink,
      'userRating': userRating,
      'price': price,
      //'requests': requests.map((r) => r.toJson()).toList(),
    };
  }

  
  static List<Book> audioBooks() {
    return [];
    //   Book(
    //     'hostory',
    //     "This is the way.",
    //     "istudio",
    //     DateTime(2019, 3, 23),
    //     'assets/images/audioBook1.jpg',
    //     4.7,
    //     892,
    //     'Ifailed the first quarter of a class in school, so I ma....',
    //     220.0,
    //   ),
    //   Book(
    //     'hostory',
    //     "This is the way.",
    //     "istudio",
    //     DateTime(2019, 3, 23),
    //     'assets/images/audioBook1.jpg',
    //     4.7,
    //     892,
    //     'Ifailed the first quarter of a class in school, so I ma....',
    //     220.0,
    //   ),
    //   Book(
    //     'hostory',
    //     "This is the way.",
    //     "istudio",
    //     DateTime(2019, 3, 23),
    //     'assets/images/audioBook1.jpg',
    //     4.7,
    //     892,
    //     'Ifailed the first quarter of a class in school, so I ma....',
    //     220.0,
    //   ),
    //   Book(
    //     'hostory',
    //     "This is the way.",
    //     "istudio",
    //     DateTime(2019, 3, 23),
    //     'assets/images/audioBook1.jpg',
    //     4.7,
    //     892,
    //     'Ifailed the first quarter of a class in school, so I ma....',
    //     220.0,
    //   ),
    //   Book(
    //     'hostory',
    //     "This is the way.",
    //     "istudio",
    //     DateTime(2019, 3, 23),
    //     'assets/images/audioBook1.jpg',
    //     3.5,
    //     892,
    //     'Ifailed the first quarter of a class in school, so I ma....',
    //     220.0,
    //   ),
    //   Book(
    //     'hostory',
    //     "This is the way.",
    //     "istudio",
    //     DateTime(2019, 3, 23),
    //     'assets/images/audioBook1.jpg',
    //     4.7,
    //     892,
    //     'Ifailed the first quarter of a class in school, so I ma....',
    //     220.0,
    //   ),
    // ];
  }
}

class Review {
  final String username;
  final String text;
  final DateTime date;

  Review({
    required this.username,
    required this.text,
    required this.date,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
        username: json['username'],
        text: json['text'],
        date: DateTime.parse(json['date']));
  }
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'text': text,
      'date': date.toIso8601String(),
    };
  }

  @override
  String toString() {
    return "${text}at :${date.toIso8601String()} by:$username";
  }
}
