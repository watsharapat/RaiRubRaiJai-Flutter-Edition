import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/account_provider.dart';
import '../../widget/emoji_picker.dart';

class EditQuickDataPage extends StatefulWidget {
  final int? index;
  final bool isIncome;
  const EditQuickDataPage({required this.isIncome, this.index, Key? key})
      : super(key: key);

  @override
  State<EditQuickDataPage> createState() => _EditQuickDataPageState();
}

class _EditQuickDataPageState extends State<EditQuickDataPage> {
  bool _isEmoji = false;
  String selectedEmoji = '🤔';
  String _title = '';
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    if (widget.index != null) {
      User uData = Provider.of<User>(context, listen: false);
      String quickData = '';
      if (widget.isIncome) {
        quickData = uData.quickTitleIncome[widget.index!];
      } else {
        quickData = uData.quickTitleCost[widget.index!];
      }
      _titleController.text = String.fromCharCodes(quickData.runes.skip(2));
      selectedEmoji = quickData.substring(0, 2);
      _title = 'Edit ${quickData}';
    } else {
      _titleController.text = '';
      _title = 'Adding ${widget.isIncome ? "income" : "cost"} title';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () => setState(() {
                            _isEmoji = !_isEmoji;
                            //? show alert dialog
                          }),
                      icon: Icon(
                        Icons.sentiment_very_satisfied,
                        color: _isEmoji
                            ? Theme.of(context).primaryColor
                            : Colors.black,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(selectedEmoji,
                        style: const TextStyle(fontSize: 24)),
                  ),
                  Flexible(
                    child: TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        hintText: 'Enter title',
                        hintStyle: const TextStyle(
                            fontSize: 24, decoration: TextDecoration.none),
                        errorText: _titleController.text.isEmpty
                            ? "title can't be empty"
                            : null,
                      ),
                      style: const TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 24,
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) {
                            List<String> userQuickTitles =
                                Provider.of<User>(context, listen: false)
                                    .quickTitleCost;
                            if (widget.isIncome) {
                              userQuickTitles =
                                  Provider.of<User>(context, listen: false)
                                      .quickTitleIncome;
                            }

                            List<Widget> simpleDialogOptions = userQuickTitles
                                .map((e) => SimpleDialogOption(
                                      onPressed: () {
                                        Navigator.pop(context, e);
                                      },
                                      child: Text(e),
                                    ))
                                .toList();

                            return userQuickTitles.isEmpty
                                ? AlertDialog(
                                    title: const Text('No quick title'),
                                    content: const Text(
                                        'You have not set any quick title yet'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  )
                                : SimpleDialog(
                                    title: const Text('Select quick title'),
                                    children: simpleDialogOptions,
                                  );
                          }).then((value) {
                        if (value != null) {
                          setState(() {
                            _titleController.text =
                                String.fromCharCodes(value.runes, 2);
                            selectedEmoji =
                                String.fromCharCode(value.runes.first);
                          });
                        }
                      });
                    },
                    icon: Icon(Icons.arrow_drop_down_circle_outlined),
                  ),
                ],
              ),
            ),
            _isEmoji
                ? Expanded(
                    child: EmojiPicker(
                    onEmojiTap: (emoji) => setState(() {
                      selectedEmoji = emoji;
                      _isEmoji = !_isEmoji;
                    }),
                  ))
                : Container(),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isEmpty) {
                  return;
                }
                String endString = "$selectedEmoji ${_titleController.text}";
                if (endString.runes.length < 3) {
                  return;
                }

                Navigator.pop(context, endString);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
