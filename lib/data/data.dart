// import '../models/post_model.dart';
// import '../models/user_model.dart';

// const User currentUser = User(
//   id: '1',
//   name: 'Richie Lorie',
//   email: 'richie@example.com',
//   imageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
//   books: [],
//   likedBooks: [],
//   requests: [],
//   followedUsers: [],
//   //mobileNumber: '',
// );

// final List<User> onlineUsers = [
//   const User(
//     id: '2',
//     name: 'David Brooks',
//     email: 'david@example.com',
//     imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
//     books: [],
//     likedBooks: [],
//     requests: [],
//     followedUsers: [],
//      // mobileNumber: '',

//   ),
//   const User(
//     id: '3',
//     name: 'Jane Doe',
//     email: 'jane@example.com',
//     imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
//     books: [],
//     likedBooks: [],
//     requests: [],
//     followedUsers: [],
//      // mobileNumber: '',

//   ),
//   const User(
//     id: '4',
//     name: 'Matthew Hinkle',
//     email: 'matthew@example.com',
//     imageUrl: 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1331&q=80',
//     books: [],
//     likedBooks: [],
//     requests: [],
//     followedUsers: [],
//       //mobileNumber: '',

//   ),
//   const User(
//     id: '5',
//     name: 'Amy Smith',
//     email: 'amy@example.com',
//     imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=700&q=80',
//     books: [],
//     likedBooks: [],
//     requests: [],
//     followedUsers: [],
//       //mobileNumber: '',

//   ),
//   const User(
//     id: '6',
//     name: 'Ed Morris',
//     email: 'ed@example.com',
//     imageUrl: 'https://images.unsplash.com/photo-1521119989659-a83eee488004?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=664&q=80',
//     books: [],
//     likedBooks: [],
//     requests: [],
//     followedUsers: [],
//      // mobileNumber: '',

//   ),
//   const User(
//     id: '7',
//     name: 'Carolyn Duncan',
//     email: 'carolyn@example.com',
//     imageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
//     books: [],
//     likedBooks: [],
//     requests: [],
//     followedUsers: [],
//      // mobileNumber: '',

//   ),
//   const User(
//     id: '8',
//     name: 'Paul Pinnock',
//     email: 'paul@example.com',
//     imageUrl: 'https://images.unsplash.com/photo-1519631128182-433895475ffe?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
//     books: [],
//     likedBooks: [],
//     requests: [],
//     followedUsers: [],
//      // mobileNumber: '',

//   ),
//   const User(
//     id: '9',
//     name: 'Elizabeth Wong',
//     email: 'elizabeth@example.com',
//     imageUrl: 'https://images.unsplash.com/photo-1515077678510-ce3bdf418862?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjF9&auto=format&fit=crop&w=675&q=80',
//     books: [],
//     likedBooks: [],
//     requests: [],
//     followedUsers: [],
//      // mobileNumber: '',

//   ),
//   const User(
//     id: '10',
//     name: 'James Lathrop',
//     email: 'james@example.com',
//     imageUrl: 'https://images.unsplash.com/photo-1528892952291-009c663ce843?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=592&q=80',
//     books: [],
//     likedBooks: [],
//     requests: [],
//     followedUsers: [],
//      // mobileNumber: '',

//   ),
//   const User(
//     id: '11',
//     name: 'Jessie Samson',
//     email: 'jessie@example.com',
//     imageUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
//     books: [],
//     likedBooks: [],
//     requests: [],
//     followedUsers: [],
//      // mobileNumber: '',

//   ),
// ];

// // final List<Post> posts = [
// //   const Post(
// //     user: currentUser,
// //     caption : 'Check out these cool puppers',
// //     timeAgo: '58m',
// //     imageUrl: 'https://images.unsplash.com/photo-1525253086316-d0c936c814f8',
// //     likes: 1202,
// //     comments: 184,
// //     shares: 96,
// //   ),
// //   Post(
// //     user: onlineUsers[5],
// //     caption : 'Please enjoy this placeholder text: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
// //     timeAgo: '3hr',
// //     imageUrl: "null",
// //     likes: 683,
// //     comments: 79,
// //     shares: 18,
// //   ),

// // ];
