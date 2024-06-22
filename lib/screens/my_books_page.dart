import 'dart:convert';
import 'dart:io';
import 'package:facebook/constants.dart';
import 'package:facebook/utils/auth_token.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../models/book_item.dart';
import '../providers/book_provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class MyBooksPage extends StatefulWidget {
  const MyBooksPage({Key? key}) : super(key: key);

  @override
  _MyBooksPageState createState() => _MyBooksPageState();
}

class _MyBooksPageState extends State<MyBooksPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    await bookProvider.fetchUserBooks();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Books'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
      body: Consumer<BookProvider>(
        builder: (context, bookProvider, child) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (bookProvider.userBooks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('You don’t have any books yet.'),
                  const SizedBox(height: 20),
                  AddBookButton(
                    onPressed: () {
                      _showAddBookDialog(context); // Show the dialog
                    },
                  ),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MasonryGridView.count(
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                crossAxisCount: 2,
                itemCount: bookProvider.userBooks.length + 1,
                itemBuilder: (_, index) {
                  if (index == 0) {
                    // The AddBookButton is the first item in the grid
                    return AddBookButton(
                      onPressed: () {
                        _showAddBookDialog(context); // Show the dialog
                      },
                    );
                  } else {
                    // Other book items
                    return BookItem(book: bookProvider.userBooks[index - 1]);
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }

  void _showAddBookDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddBookDialog();
      },
    );
  }
}

class AddBookDialog extends StatefulWidget {
  @override
  _AddBookDialogState createState() => _AddBookDialogState();
}

class _AddBookDialogState extends State<AddBookDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _pdfLinkController = TextEditingController();
  final _priceController = TextEditingController();
  XFile? _pickedImage;
  String? _selectedType;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = image;
        _imageUrlController.text = image.path;
      });
    }
  }

  bool _isValidPdfUrl(String url) {
    final regex = RegExp(
        r'^(https:\/\/www\.bookleaks\.com\/files\/ketab\/ketab2\/\d+\.pdf)$');
    return regex.hasMatch(url);
  }

  Future<String> _uploadImage(File file) async {
    String fileName = path.basename(file.path);
    Reference storageReference =
        FirebaseStorage.instance.ref().child('books/$fileName');
    UploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.whenComplete(() => null);
    String returnURL = await storageReference.getDownloadURL();
    return returnURL;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String? imageUrl;
      if (_pickedImage != null) {
        imageUrl = await _uploadImage(File(_pickedImage!.path));
      }

      String title = _titleController.text;
      String author = _authorController.text;
      String description = _descriptionController.text;
      String type = _selectedType!;
      String? pdfLink = _pdfLinkController.text;
      double? price = type == 'pdf' ? 0 : double.tryParse(_priceController.text);

      Map<String, dynamic> bookData = {
        'title': title,
        'author': author,
        'description': description,
        'type': type,
        'image': imageUrl,
        'pdfLink': type == 'pdf' ? pdfLink : null,
        'price': price,
        'location': type == 'physical' ? 'baita' : null,

      };

      await _createBook(bookData);
    }
  }

  Future<void> _createBook(Map<String, dynamic> bookData) async {
  String token = AuthToken().getToken;
  final response = await http.post(
    Uri.parse('http://$ip:$port/api/books'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(bookData),
  );

  if (response.statusCode == 201) {
    // Book created successfully
    Provider.of<BookProvider>(context, listen: false).addBook(Book.fromJson(jsonDecode(response.body)));
    Navigator.of(context).pop();
  } else {
    // Log the error response
    print('Failed to add book. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    // Handle error
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: const Text('Failed to add book. Please try again later.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Book'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: _pickedImage == null
                      ? const Icon(Icons.add_a_photo,
                          size: 50, color: Colors.grey)
                      : Image.file(
                          File(_pickedImage!.path),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the author';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Type'),
                items: const [
                  DropdownMenuItem(
                    value: 'pdf',
                    child: Text('pdf'),
                  ),
                  DropdownMenuItem(
                    value: 'physical',
                    child: Text('physical'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a type';
                  }
                  return null;
                },
              ),
              if (_selectedType == 'pdf')
                TextFormField(
                  controller: _pdfLinkController,
                  decoration: const InputDecoration(labelText: 'pdf Link'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the PDF link';
                    }
                    // if (!_isValidPdfUrl(value)) {
                    //   return 'Please enter a correct PDF link like https://www.bookleaks.com/files/ketab/ketab2/657.pdf';
                    // }
                    // return null;
                  },
                ),
              if (_selectedType == 'physical')
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the price';
                    }
                    return null;
                  },
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Add Book'),
        ),
      ],
    );
  }
}
class AddBookButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddBookButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        height: 220,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(.1),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 40, color: Colors.black),
            SizedBox(height: 8),
            Text(
              'Add New Book',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
