import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/book.dart';
import '../models/book_item.dart';

import '../services/book_service.dart';

class BookGridView extends StatefulWidget {
  final int selected;
  final TrackingScrollController scrollController;
  final Function callback;

  BookGridView(this.selected, this.scrollController, this.callback,
      {super.key});

  @override
  _BookGridViewState createState() => _BookGridViewState();
}

class _BookGridViewState extends State<BookGridView> {
  late Future<List<Book>> _bookList;

  @override
  void initState() {
    super.initState();
    _bookList = BookService().fetchPhysicalBooks();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: _bookList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No books available'));
        } else {
          return ListView(
            controller: widget.scrollController,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: MasonryGridView.count(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  crossAxisCount: 2,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) =>
                      BookItem(book: snapshot.data![index]),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class BookGridViewDesktop extends StatefulWidget {
  final int selected;
  final TrackingScrollController scrollController;
  final Function callback;

  BookGridViewDesktop(this.selected, this.scrollController, this.callback,
      {super.key});

  @override
  _BookGridViewDesktopState createState() => _BookGridViewDesktopState();
}

class _BookGridViewDesktopState extends State<BookGridViewDesktop> {
  late Future<List<Book>> _bookList;

  @override
  void initState() {
    super.initState();
    _bookList = BookService().fetchPhysicalBooks();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: _bookList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No books available'));
        } else {
          return ListView(
            controller: widget.scrollController,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: MasonryGridView.count(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) =>
                      BookItem(book: snapshot.data![index]),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class PdfBookGridView extends StatefulWidget {
  final int selected;
  final TrackingScrollController scrollController;
  final Function callback;

  PdfBookGridView(this.selected, this.scrollController, this.callback,
      {super.key});

  @override
  _PdfBookGridViewState createState() => _PdfBookGridViewState();
}

class _PdfBookGridViewState extends State<PdfBookGridView> {
  late Future<List<Book>> _bookList;

  @override
  void initState() {
    super.initState();
    _bookList = BookService().fetchPDFBooks();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: _bookList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No books available'));
        } else {
          return ListView(
            controller: widget.scrollController,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: MasonryGridView.count(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  crossAxisCount: 2,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) =>
                      BookItem(book: snapshot.data![index]),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

// Similar updates can be made for the other grid view classes

class PdfBookGridViewDesktop extends StatefulWidget {
  final int selected;
  final TrackingScrollController scrollController;
  final Function callback;

  PdfBookGridViewDesktop(this.selected, this.scrollController, this.callback,
      {super.key});

  @override
  _PdfBookGridViewDesktopState createState() => _PdfBookGridViewDesktopState();
}

class _PdfBookGridViewDesktopState extends State<PdfBookGridViewDesktop> {
  late Future<List<Book>> _bookList;

  @override
  void initState() {
    super.initState();
    _bookList = BookService().fetchPDFBooks();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: _bookList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No books available'));
        } else {
          return ListView(
            controller: widget.scrollController,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: MasonryGridView.count(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) =>
                      BookItem(book: snapshot.data![index]),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
