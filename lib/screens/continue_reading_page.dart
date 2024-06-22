// import 'dart:io';

// import 'package:facebook/widgets/PDF_viewer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class ContinueReadingPage extends StatefulWidget {
//   @override
//   _ContinueReadingPageState createState() => _ContinueReadingPageState();
// }

// class _ContinueReadingPageState extends State<ContinueReadingPage> {
//   List<String> savedBooks = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadSavedBooks();
//   }

//   Future<void> _loadSavedBooks() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       savedBooks = prefs.getStringList('savedBooks') ?? [];
//     });
//   }

//   Future<String> _downloadFile(String url) async {
//     final filename = url.split('/').last;
//     final dir = await getApplicationDocumentsDirectory();
//     final file = File('${dir.path}/$filename');

//     if (await file.exists()) {
//       return file.path;
//     } else {
//       final response = await http.get(Uri.parse(url));
//       await file.writeAsBytes(response.bodyBytes);
//       return file.path;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Continue Reading'),
//       ),
//       body: ListView.builder(
//         itemCount: savedBooks.length,
//         itemBuilder: (context, index) {
//           final bookUrl = savedBooks[index];
//           return FutureBuilder<String>(
//             future: _downloadFile(bookUrl),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return ListTile(
//                   title: Text('Loading...'),
//                   subtitle: Text(bookUrl),
//                 );
//               } else if (snapshot.hasError) {
//                 return ListTile(
//                   title: Text('Error loading book'),
//                   subtitle: Text(bookUrl),
//                 );
//               }

//               final filePath = snapshot.data!;
//               return ListTile(
//                 title: Text('Book $index'),
//                 subtitle: Text(bookUrl),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => PdfViewerPage(pdfBook: bookUrl),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
