import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data_model/date.dart';
import '../../data_model/edit_pass_argu.dart';
import '../../provider/account_provider.dart';
import '../../util.dart';

class EditSelectDataMonth extends StatelessWidget {
  final Date monthYearSelected;
  const EditSelectDataMonth({required this.monthYearSelected, Key? key})
      : super(key: key);

  Widget rowDate(BuildContext context, Date date, bool isFirst) {
    String todayStr = " ${getMonthName(date.month)} ${date.year}";
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

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, uData, child) {
        List<Widget> widgets = [];
        bool _isFirst = true;
        for (int i = 1; i <= monthYearSelected.numDayOfMonth; i++) {
          var date = Date(monthYearSelected.year, monthYearSelected.month, i);
          if (date.compareTo(Date.today()) > 0) break;
          widgets.add(rowDate(context, date, _isFirst));
          var monthData = uData.accountsData.getAccountsOnDate(date);

          if (monthData.isEmpty) {
            widgets.add(const Center(
                child: Text("No data...\n", style: TextStyle(fontSize: 20))));
          } else {
            for (int i = 0; i < monthData.length; i++) {
              var account = monthData[i];
              widgets.add(
                Card(
                  color: account.isPositive ? Colors.green[50] : Colors.red[50],
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        "/editData",
                        arguments: EditPassArgu(date: date, index: i),
                      );
                    },
                    title: AutoSizeText(
                        "${account.icon} ${account.title} : ${account.amount}",
                        style: const TextStyle(fontSize: 24.0),
                        maxLines: 1),
                    trailing: const Icon(Icons.edit),
                  ),
                ),
              );
            }
          }

          _isFirst = false;
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(
                'Select to edit ${getMonthName(monthYearSelected.month)} ${monthYearSelected.year}'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(12.0),
            children: widgets,
          ),
        );
      },
    );
  }
}
