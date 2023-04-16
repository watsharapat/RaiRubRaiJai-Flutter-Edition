import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './edit_data.dart';

import '../../provider/account_provider.dart';

class QuickEditPage extends StatefulWidget {
  final bool isIncome;
  const QuickEditPage({required this.isIncome, Key? key}) : super(key: key);

  @override
  State<QuickEditPage> createState() => _QuickEditPageState();
}

class _QuickEditPageState extends State<QuickEditPage> {
  bool _isReorder = false;
  List<String> oldTitleData = [];
  List<String> titleData = [];

  void pushToDataToCloud() {
    User uData = Provider.of<User>(context, listen: false);
    if (widget.isIncome) {
      uData.quickTitleIncome = List.from(titleData);
    } else {
      uData.quickTitleCost = List.from(titleData);
    }
    uData.onUpdateData();
  }

  @override
  void initState() {
    super.initState();

    User uData = Provider.of<User>(context, listen: false);
    if (widget.isIncome) {
      titleData = List.from(uData.quickTitleIncome);
    } else {
      titleData = List.from(uData.quickTitleCost);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quick ${widget.isIncome ? "income" : "cost"} title'),
        actions: _isReorder
            ? [
                IconButton(
                  onPressed: () => setState(() {
                    //Reset the reorder
                    print(">>>>>OLD as UNDO : ${oldTitleData}");
                    titleData = List.from(oldTitleData);
                  }),
                  icon: Icon(Icons.undo),
                ),
                IconButton(
                  onPressed: () => setState(() {
                    //save the reorder
                    pushToDataToCloud();
                    _isReorder = !_isReorder;
                  }),
                  icon: Icon(Icons.check),
                ),
              ]
            : [
                IconButton(
                  onPressed: () {
                    Navigator.push<String>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditQuickDataPage(
                          isIncome: widget.isIncome,
                        ),
                      ),
                    ).then((value) {
                      if (value != null) {
                        if (titleData.contains(value)) {
                          return;
                        }
                        setState(() {
                          titleData.add(value);
                          pushToDataToCloud();
                        });
                      }
                    });
                  },
                  icon: Icon(Icons.add),
                ),
                IconButton(
                  onPressed: () => setState(() {
                    oldTitleData = List.from(titleData);
                    _isReorder = !_isReorder;
                  }),
                  icon: Icon(Icons.reorder),
                ),
              ],
        automaticallyImplyLeading: !_isReorder,
      ),
      body: _isReorder
          ? ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                print("?????????? REORDER : $oldIndex to $newIndex");
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final String item = titleData.removeAt(oldIndex);
                  titleData.insert(newIndex, item);
                });
              },
              children: [
                for (int index = 0; index < titleData.length; index++)
                  ListTile(
                    tileColor: index.isEven ? Colors.grey[200] : null,
                    key: ValueKey(titleData[index]),
                    title: Text(titleData[index]),
                    trailing: ReorderableDragStartListener(
                      index: index,
                      child: const Icon(Icons.drag_handle),
                    ),
                  ),
              ],
            )
          : ListView.builder(
              itemCount: titleData.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(titleData[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push<String>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditQuickDataPage(
                                  isIncome: widget.isIncome,
                                  index: index,
                                ),
                              ),
                            ).then((value) {
                              if (value != null) {
                                if (titleData.contains(value)) {
                                  return;
                                }
                                setState(() {
                                  titleData[index] = value;
                                  pushToDataToCloud();
                                });
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            //? show dialog to confirm delete
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Delete ${titleData[index]}?'),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Cancel')),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        titleData.removeAt(index);
                                        pushToDataToCloud();
                                      });
                                    },
                                    child: Text('Delete'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ));
              },
            ),
    );
  }
}
