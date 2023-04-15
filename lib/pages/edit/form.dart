import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rai_rub_rai_jai/data_model/date.dart';
import '../../data_model/account_data.dart';
import '../../provider/account_provider.dart';
import '../../util.dart';
import '../../widget/emoji_picker.dart';

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class AddEditPage extends StatefulWidget {
  final Date initDate;
  final int? initIndex;
  const AddEditPage({required this.initDate, this.initIndex, Key? key})
      : super(key: key);

  @override
  State<AddEditPage> createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  late Date _date;
  bool _isEmoji = false;
  String selectedEmoji = '🤔';
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? amountError = "amount can't be empty";

  @override
  void initState() {
    _date = widget.initDate.copyWith();
    if (widget.initIndex != null) {
      User uData = Provider.of<User>(context, listen: false);
      Account data =
          uData.accountsData.getAccountsOnDate(_date)[widget.initIndex!];
      _amountController.text = data.amount.toString();
      _titleController.text = data.title;
      _descriptionController.text = data.description;
      selectedEmoji = data.icon;
      amountError = null;
    } else {
      _amountController.text = '';
      _titleController.text = '';
      _descriptionController.text = '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String dateString =
        "${_date.day} ${getMonthName(_date.month)} ${_date.year} ";

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initIndex == null ? 'Add' : 'Edit'),
        actions: widget.initIndex == null
            ? []
            : [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Delete'),
                          content:
                              const Text('Are you sure to delete this item?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                User uData =
                                    Provider.of<User>(context, listen: false);
                                uData.accountsData.removeAccountAtIndex(
                                  _date,
                                  widget.initIndex!,
                                );
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: GestureDetector(
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime(_date.year, _date.month, _date.day),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        _date = Date(
                          value.year,
                          value.month,
                          value.day,
                        );
                      });
                    }
                  });
                },
                child: Row(
                  children: [
                    Text(dateString, style: const TextStyle(fontSize: 36.0)),
                    const Icon(Icons.edit),
                  ],
                ),
              ),
            ),
            //? amount
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20),
              child: TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  hintText: 'Enter amount',
                  hintStyle: const TextStyle(
                      fontSize: 24, decoration: TextDecoration.none),
                  errorText: amountError,
                ),
                style: const TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 24,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.singleLineFormatter
                ],
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      amountError = "amount can't be empty";
                    } else {
                      try {
                        int.parse(value);
                      } on FormatException catch (e) {
                        amountError = "amount must be number";
                      }
                      amountError = null;
                    }
                  });
                },
              ),
            ),
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
                            if (_amountController.text.isEmpty ||
                                int.parse(_amountController.text) >= 0) {
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
            Padding(
              padding: EdgeInsets.only(top: 10, left: 20),
              child: TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter description',
                  hintStyle:
                      TextStyle(fontSize: 18, decoration: TextDecoration.none),
                ),
                style: const TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 18,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () {
                      //? valid data
                      print(">>>>>>>>>>>>valid Data");
                      if (amountError != null ||
                          _titleController.text.isEmpty) {
                        return;
                      }
                      String endString =
                          "$selectedEmoji ${_titleController.text}";
                      if (endString.runes.length < 3) {
                        return;
                      }

                      var uData = Provider.of<User>(context, listen: false);

                      if (widget.initIndex != null) {
                        //? edit
                        uData.accountsData.removeAccountAtIndex(
                            widget.initDate, widget.initIndex!);
                        uData.accountsData.addAccountAtDay(
                            _date,
                            Account(
                              int.parse(_amountController.text),
                              endString,
                              _descriptionController.text,
                            ));
                      } else {
                        uData.accountsData.addAccountAtDay(
                            _date,
                            Account(
                              int.parse(_amountController.text),
                              endString,
                              _descriptionController.text,
                            ));
                      }

                      Navigator.pop(context);
                    },
                    child: Text(widget.initIndex != null ? 'Save' : 'Add')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
