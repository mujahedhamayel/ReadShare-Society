// import 'package:facebook/models/book.dart';
// import 'package:facebook/services/book_service.dart';
// import 'package:flutter/material.dart';


// class UserRequestsPage extends StatefulWidget {
//   @override
//   _UserRequestsPageState createState() => _UserRequestsPageState();
// }

// class _UserRequestsPageState extends State<UserRequestsPage> {
//   final BookService _bookService = BookService();
//   late Future<List<Book>> _requestsFuture;

//   @override
//   void initState() {
//     super.initState();
//     _requestsFuture = _bookService.fetchUserBookRequests();
//   }

//   void _refreshRequests() {
//     setState(() {
//       _requestsFuture = _bookService.fetchUserBookRequests();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Book Requests'),
//       ),
//       body: FutureBuilder<List<Book>>(
//         future: _requestsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No requests found'));
//           }

//           return ListView.builder(
//             itemCount: snapshot.data!.length,
//             itemBuilder: (context, index) {
//               final book = snapshot.data![index];
//               return BookRequestCard(
//                 book: book,
//                 onRequestAccepted: _refreshRequests,
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class BookRequestCard extends StatelessWidget {
//   final Book book;
//   final VoidCallback onRequestAccepted;

//   const BookRequestCard({
//     Key? key,
//     required this.book,
//     required this.onRequestAccepted,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.all(8.0),
//       child: Padding(
//         padding: EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Image.network(book.imgUrl, width: 50, height: 50),
//                 SizedBox(width: 10),
//                 Text(book.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               ],
//             ),
//             SizedBox(height: 10),
//             ...book.requests.map((request) {
//               return ListTile(
//                 title: Text(request.user.name),
//                 subtitle: Text('Status: ${request.status}'),
//                 trailing: request.status == 'requested'
//                     ? ElevatedButton(
//                         onPressed: () async {
//                           await BookService().acceptRequest(book.id, request.id);
//                           onRequestAccepted();
//                         },
//                         child: Text('Accept'),
//                       )
//                     : Text('Accepted', style: TextStyle(color: Colors.green)),
//               );
//             }).toList(),
//           ],
//         ),
//       ),
//     );
//   }
// }
