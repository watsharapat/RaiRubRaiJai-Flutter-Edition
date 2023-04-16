import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rai_rub_rai_jai/data_model/date.dart';

import '../../data_model/account_data.dart';
import '../../data_model/edit_pass_argu.dart';
import '../../provider/account_provider.dart';
import '../../util.dart';

class TodayDataList extends StatefulWidget {
  const TodayDataList({Key? key}) : super(key: key);

  @override
  State<TodayDataList> createState() => _TodayDataListState();
}

class _TodayDataListState extends State<TodayDataList> {
  int maxSize = 30;

  Widget rowDate(BuildContext context, Date date, bool isToday, bool isFirst) {
    String todayStr =
        " ${getMonthName(date.month)} ${date.year}${isToday ? " (Today)" : ""}";
    return Padding(
      padding: EdgeInsets.only(top: isFirst ? 0 : 30),
      child: Row(
        children: [
          Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 36.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Text(
            todayStr,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget rowAccount(
      BuildContext context, Account account, Date date, int index) {
    return GestureDetector(
      child: Card(
        color: account.isPositive
            ? Colors.greenAccent[100]
            : Colors.redAccent[100],
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: AutoSizeText(
              "${account.icon} ${account.title} : ${account.amount}",
              style: const TextStyle(fontSize: 24.0),
              maxLines: 1),
        ),
      ),
      onTap: () {
        //? show info via dialog

        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor:
                    account.isPositive ? Colors.green[50] : Colors.red[50],
                title: Text("${account.amount}\$",
                    style: TextStyle(fontSize: 24.0)),
                content: Text(
                    '${account.fullTitle}\n${(account.description == "") ? "\nNo description" : account.description}'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          "/editData",
                          arguments: EditPassArgu(date: date, index: index),
                        );
                      },
                      child: Text("edit")),
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("OK")),
                ],
              );
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, value, child) {
        var dates = value.accountsData.getAllDate();
        if (dates.isEmpty) {
          return const Center(child: Text("No data\n"));
        }

        dates.sort((a, b) => b.compareTo(a));

        List<Widget> widgets = [];
        var accountOnToday = value.accountsData.getAccountsOnDate(Date.today());
        widgets.add(rowDate(context, Date.today(), true, true));
        if (accountOnToday.isEmpty) {
          widgets.add(const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Center(child: Text("No data :|\n"))));
        } else {
          for (int i = 0; i < accountOnToday.length; i++) {
            var account = accountOnToday[i];
            widgets.add(rowAccount(context, account, Date.today(), i));
          }
        }
        widgets.add(Divider(
          color: Theme.of(context).primaryColor,
          thickness: 1,
        ));

        bool isFirst = true;
        for (var date in dates) {
          var accountOnDate = value.accountsData.getAccountsOnDate(date);
          if (accountOnDate.isEmpty) {
            continue;
          }
          widgets.add(rowDate(context, date, false, isFirst));
          isFirst = false;

          for (int i = 0; i < accountOnDate.length; i++) {
            var account = accountOnDate[i];
            widgets.add(rowAccount(context, account, date, i));
          }

          if (widgets.length > maxSize) {
            widgets.add(
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => setState(() {
                      maxSize += maxSize ~/ 3 + 30;
                    }),
                    child: const Text(
                      "Load more...",
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ),
                ),
              ),
            );
            break;
          }
        }

        if (widgets.length <= maxSize) {
          widgets.add(const Center(
              child: Text("EOF\n", style: TextStyle(fontSize: 20))));
        }

        return ListView(
          children: widgets,
        );
      },
    );
  }
}
