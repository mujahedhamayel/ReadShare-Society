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

    // this.height,
  );

  // fromJson method to create an instance of Book from a JSON object
  factory Book.fromJson(Map<String, dynamic> json) {
    var reviewList = (json['reviews'] as List)
        .map((reviewJson) => Review.fromJson(reviewJson))
        .toList();

    var likesList =
        (json['likes'] as List<dynamic>).map((like) => like as String).toList();

    return Book(
      json['type'],
      json['title'],
      json['owner'] ?? {},   //user: User.fromJson(json['user'] ?? {}), // Handle null user
      DateTime.parse(json['updatedAt']),
      json['image'],
      json['author'],
      json['location'],
      4.7, //rate
      reviewList,
      json['_id'],
      likesList,
      json['pdfLink'],
    );
  }

  // toJson method to convert an instance of Book to a JSON object (optional)
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'owner': owner,
      'updatedAt': updateDate.toIso8601String(),
      'image': imgUrl,
      'author': author,
      'location': location,
      '_id': id,
      'likes': likes,
      'pdfLink': pdfLink,
    };
  }

  // static List<Book> freeBooks() {
  //   return [
  //     Book(
  //       'hostory',
  //       "This is the way.",
  //       "istudio",
  //       DateTime(2019, 3, 23),
  //       'assets/images/book3.jpg',
  //       4.7,
  //       892,
  //       'Ifailed the first quarter of a class in school, so I ma....',
  //       220.0,
  //     ),
  //     Book(
  //       'hostory',
  //       "This is the way.",
  //       "istudio",
  //       DateTime(2019, 3, 23),
  //       'assets/images/book3.jpg',
  //       4.7,
  //       892,
  //       'Ifailed the first quarter of a class in school, so I ma....',
  //       220.0,
  //     ),
  //     Book(
  //       'hostory',
  //       "This is the way.",
  //       "istudio",
  //       DateTime(2019, 3, 23),
  //       'assets/images/book3.jpg',
  //       4.7,
  //       892,
  //       'Ifailed the first quarter of a class in school, so I ma....',
  //       220.0,
  //     ),
  //     Book(
  //       'hostory',
  //       "This is the way.",
  //       "istudio",
  //       DateTime(2019, 3, 23),
  //       'assets/images/book3.jpg',
  //       4.7,
  //       892,
  //       'Ifailed the first quarter of a class in school, so I ma....',
  //       220.0,
  //     ),
  //     Book(
  //       'hostory',
  //       "This is the way.",
  //       "istudio",
  //       DateTime(2019, 3, 23),
  //       'assets/images/book1.png',
  //       4.7,
  //       892,
  //       'Ifailed the first quarter of a class in school, so I ma....',
  //       220.0,
  //     ),
  //     Book(
  //       'hostory',
  //       "This is the way.",
  //       "istudio",
  //       DateTime(2019, 3, 23),
  //       'assets/images/book2.jpg',
  //       4.7,
  //       892,
  //       'Ifailed the first quarter of a class in school, so I ma....',
  //       220.0,
  //     ),
  //     Book(
  //       'hostory',
  //       "This is the way.",
  //       "istudio",
  //       DateTime(2019, 3, 23),
  //       'assets/images/book1.png',
  //       4.7,
  //       892,
  //       'Ifailed the first quarter of a class in school, so I ma....',
  //       220.0,
  //     ),
  //     Book(
  //       'hostory',
  //       "This is the way.",
  //       "istudio",
  //       DateTime(2019, 3, 23),
  //       'assets/images/book1.png',
  //       4.7,
  //       892,
  //       'Ifailed the first quarter of a class in school, so I ma....',
  //       220.0,
  //     )
  //   ];
  // }

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
