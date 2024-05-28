class Book {
  String type;
  String title;
  String owner;
  DateTime updateDate;
  String imgUrl;
  String author;
  String location;
  num rate;
  String review;
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
    // this.height,
  );

  // fromJson method to create an instance of Book from a JSON object
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      json['type'],
      json['title'],
      json['owner'],
      DateTime.parse(json['updatedAt']),
      json['image'],
      json['author'],
      json['location'],
      4.7, //rate
      'Ifailed the first quarter of a class in school, so I ma....',
      
      // json['ratings'],
      // json['review'],
      // json['height'],
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
