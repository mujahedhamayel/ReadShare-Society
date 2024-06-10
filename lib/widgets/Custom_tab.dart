import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  final int selected;
  final Function callback;
  CustomTab(this.selected, this.callback, {super.key});
  final tabs = ['Physical Books', 'PDF Books'];
  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(5),
        ),
        width: isSmallScreen ? 400 : 500,
        height: 56,
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) => GestureDetector(
                  onTap: () => callback(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          selected == index ? Colors.white : Colors.grey[200],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    alignment: Alignment.center,
                    width: (isSmallScreen ? 400 : 500 - 40) / 2 - 10,
                    child: Text(
                      tabs[index],
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            separatorBuilder: (_, index) => const SizedBox(width: 10),
            itemCount: tabs.length),
      ),
    );
  }
}
