import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../models/book_item.dart';
import '../providers/book_provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';

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
    final _formKey = GlobalKey<FormState>();
    final _titleController = TextEditingController();
    final _authorController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _imageUrlController = TextEditingController();
    final _priceController =
        TextEditingController(); // Controller for the price field
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                        value: 'PDF',
                        child: Text('PDF'),
                      ),
                      DropdownMenuItem(
                        value: 'Physical',
                        child: Text('Physical'),
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
                  // Render PDF file upload field if PDF is selected
                  if (_selectedType == 'PDF')
                    ElevatedButton(
                      onPressed: () {
                        // Implement PDF upload logic here
                      },
                      child: const Text('Upload PDF File'),
                    ),
                  // Render price field if Physical is selected
                  if (_selectedType == 'Physical')
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
              onPressed: () {
                /*  if (_formKey.currentState!.validate()) {
                  final bookProvider =
                      Provider.of<BookProvider>(context, listen: false);
                  final newBook = Book(
                    id: DateTime.now().toString(),
                    title: _titleController.text,
                    author: _authorController.text,
                    description: _descriptionController.text,
                    imageUrl: _pickedImage != null ? _pickedImage!.path : '',
                    type: _selectedType!,
                    price: _selectedType == 'Physical'
                        ? double.tryParse(_priceController.text) ?? 0.0
                        : null, // Set price only if type is Physical
                  );
                  bookProvider.addBook(newBook);
                  Navigator.of(context).pop();
                }*/
              },
              child: const Text('Add Book'),
            ),
          ],
        );
      },
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
