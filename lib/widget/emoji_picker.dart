import 'package:auto_size_text/auto_size_text.dart';

import '../data/emoji.dart';
import 'package:flutter/material.dart';

typedef EmojiTapCallback = void Function(String emoji);

final Map<String, String> emojiDatas = getEmojiInCategory();
final List<String> emojiCategories = emojiDatas.keys.toList();

class EmojiPicker extends StatefulWidget {
  final EmojiTapCallback onEmojiTap;

  const EmojiPicker({Key? key, required this.onEmojiTap}) : super(key: key);

  @override
  _EmojiPickerState createState() => _EmojiPickerState();
}

class _EmojiPickerState extends State<EmojiPicker> {
  int _selectedCategoriesIndex = 0;

  @override
  void initState() {
    _selectedCategoriesIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: emojiCategories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategoriesIndex = index;
                  });
                },
                child: Container(
                  child: Card(
                    color: _selectedCategoriesIndex == index
                        ? Colors.blue
                        : Colors.white,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: AutoSizeText(
                          emojiCategories[index],
                          style: const TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          flex: 9,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
            ),
            itemCount: emojiDatas[emojiCategories[_selectedCategoriesIndex]]!
                .runes
                .length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  widget.onEmojiTap(String.fromCharCodes(
                      emojiDatas[emojiCategories[_selectedCategoriesIndex]]!
                          .runes,
                      index,
                      index + 1));
                },
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      String.fromCharCodes(
                          emojiDatas[emojiCategories[_selectedCategoriesIndex]]!
                              .runes,
                          index,
                          index + 1),
                      style: const TextStyle(fontSize: 24.0),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
