import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/models.dart';

class BookGridView extends StatelessWidget {
  final int selected;
  final TrackingScrollController scrollController;
  final Function callback;
  BookGridView(this.selected, this.scrollController, this.callback,
      {super.key});

  final bookListfree = Book.freeBooks();

  @override
  Widget build(BuildContext context) {
    return ListView(
      // Use ListView or CustomScrollView
      controller: scrollController,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: MasonryGridView.count(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            crossAxisCount: 2,
            itemCount: bookListfree.length,
            itemBuilder: (_, index) => BookItem(book: bookListfree[index]),
          ),
        ),
      ],
    );
  }
}

class BookGridViewDesktop extends StatelessWidget {
  final int selected;
  final TrackingScrollController scrollController;
  final Function callback;
  BookGridViewDesktop(this.selected, this.scrollController, this.callback,
      {super.key});

  final bookListfree = Book.freeBooks();

  @override
  Widget build(BuildContext context) {
    return ListView(
      // Use ListView or CustomScrollView
      controller: scrollController,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: MasonryGridView.count(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            crossAxisCount: 4,
            itemCount: bookListfree.length,
            itemBuilder: (_, index) => BookItem(book: bookListfree[index]),
          ),
        ),
      ],
    );
  }
}

class AudioBookGridView extends StatelessWidget {
  final int selected;
  final TrackingScrollController scrollController;
  final Function callback;
  AudioBookGridView(this.selected, this.scrollController, this.callback,
      {super.key});

  final bookListAudio = Book.audioBooks();

  @override
  Widget build(BuildContext context) {
    return ListView(
      // Use ListView or CustomScrollView
      controller: scrollController,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: MasonryGridView.count(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            crossAxisCount: 2,
            itemCount: bookListAudio.length,
            itemBuilder: (_, index) => BookItem(book: bookListAudio[index]),
          ),
        ),
      ],
    );
  }
}

class AudioBookGridViewDesktop extends StatelessWidget {
  final int selected;
  final TrackingScrollController scrollController;
  final Function callback;
  AudioBookGridViewDesktop(this.selected, this.scrollController, this.callback,
      {super.key});

  final bookListAudio = Book.audioBooks();

  @override
  Widget build(BuildContext context) {
    return ListView(
      // Use ListView or CustomScrollView
      controller: scrollController,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: MasonryGridView.count(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            crossAxisCount: 4,
            itemCount: bookListAudio.length,
            itemBuilder: (_, index) => BookItem(book: bookListAudio[index]),
          ),
        ),
      ],
    );
  }
}
