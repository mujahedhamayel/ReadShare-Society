import 'package:facebook/config/palette.dart';
import 'package:facebook/data/data.dart';
import '/widgets/widgets.dart';
import 'package:flutter/material.dart';

class BooksContent extends StatefulWidget {
  const BooksContent({super.key});

  @override
  _BooksContentState createState() => _BooksContentState();
}

class _BooksContentState extends State<BooksContent> {
  final TrackingScrollController _trackingScrollController =
      TrackingScrollController();

  int tabIndex = 0;

  void updateTabIndex(int index) {
    setState(() {
      tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Responsive(
          mobile: _BookScreenMobile(
            scrollController: _trackingScrollController,
            tabIndex: tabIndex,
            onTabIndexChanged: updateTabIndex,
          ),
          desktop: _BookScreenDesktop(
            scrollController: _trackingScrollController,
            tabIndex: tabIndex,
            onTabIndexChanged: updateTabIndex,
          ),
          tablet: _BookScreenMobile(
            scrollController: _trackingScrollController,
            tabIndex: tabIndex,
            onTabIndexChanged: updateTabIndex,
          ),
        ),
      ),
    );
  }
}

class _BookScreenDesktop extends StatelessWidget {
  final TrackingScrollController scrollController;
  final int tabIndex;
  final Function(int) onTabIndexChanged;

  const _BookScreenDesktop({
    required this.scrollController,
    required this.tabIndex,
    required this.onTabIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: MoreOptionsList(currentUser: currentUser),
            ),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 800.0,
          child: Column(
            children: [
              CustomTab(tabIndex, onTabIndexChanged),
              Expanded(
                child: tabIndex == 0
                    ? BookGridViewDesktop(
                        tabIndex,
                        scrollController,
                        onTabIndexChanged,
                      )
                    : AudioBookGridViewDesktop(
                        tabIndex,
                        scrollController,
                        onTabIndexChanged,
                      ),
              )
            ],
          ),
        ),
        const Spacer(),
        Flexible(
          flex: 2,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ContactsList(users: onlineUsers),
            ),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class _BookScreenMobile extends StatelessWidget {
  final TrackingScrollController scrollController;
  final int tabIndex;
  final Function(int) onTabIndexChanged;

  const _BookScreenMobile({
    required this.scrollController,
    required this.tabIndex,
    required this.onTabIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'ReadShare',
            style: TextStyle(
              color: Palette.REDcolor,
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              letterSpacing: -1.2,
            ),
          ),
        ),
        body: Column(
          children: [
            CustomTab(tabIndex, onTabIndexChanged),
            Expanded(
              child: tabIndex == 0
                  ? BookGridView(
                      tabIndex,
                      scrollController,
                      onTabIndexChanged,
                    )
                  : AudioBookGridView(
                      tabIndex,
                      scrollController,
                      onTabIndexChanged,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
