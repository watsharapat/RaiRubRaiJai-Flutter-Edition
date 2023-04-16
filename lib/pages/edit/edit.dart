import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data_model/date.dart';
import '../../provider/account_provider.dart';
import '../../widget/bottom_bar.dart';
import '../../util.dart';

class EditPage extends StatelessWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(builder: (context, value, child) {
      var dates = value.accountsData.getAllDate();

      List<Widget> widgets = [];
      List<Date> monthYears =
          dates.map((e) => Date(e.year, e.month, 0)).toSet().toList();
      monthYears.sort((a, b) => b.compareTo(a));

      List<Date> monthYearsWithDivider = [];
      var lyear = 999;
      for (var monthYear in monthYears) {
        if (lyear != monthYear.year) {
          lyear = monthYear.year;
          monthYearsWithDivider.add(Date(lyear, 0, 0));
        }
        monthYearsWithDivider.add(monthYear);
      }

      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            itemCount: monthYearsWithDivider.length,
            itemBuilder: (context, index) {
              if (monthYearsWithDivider[index].month == 0) {
                return Text(
                  "${monthYearsWithDivider[index].year}",
                  style: TextStyle(
                      fontSize: 36,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                );
              } else {
                var _ICmonth = value.accountsData
                    .getIncomeAndCostAtMonth(monthYearsWithDivider[index]);
                int delta = _ICmonth.income + _ICmonth.cost;

                return Card(
                  color:
                      (delta) >= 0 ? Colors.green.shade50 : Colors.red.shade50,
                  child: ListTile(
                    title: Text(
                        "${getMonthName(monthYearsWithDivider[index].month)} Δ$delta"),
                    subtitle: Text("+${_ICmonth.income}\$  ${_ICmonth.cost}\$"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.pushNamed(context, "/edit_month",
                          arguments: monthYearsWithDivider[index]);
                    },
                  ),
                );
              }
            },
          ),
        ),
        bottomNavigationBar: const BottomAppBar(
          child: BottomNavigation(focused: BottomPages.edit),
        ),
      );
    });
  }
}
