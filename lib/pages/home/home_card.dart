import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data_model/account_data.dart';
import '../../data_model/date.dart';
import '../../provider/account_provider.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = MediaQuery.of(context).size.width < 600;
    return Consumer<User>(builder: (context, value, child) {
      final int moneySummary =
          value.accountsData.getAccumulatedBeforeDay(Date.today());
      final List<Account> allData = value.accountsData.getAllAccounts();
      final int costMonth =
          value.accountsData.getIncomeAndCostAtMonth(Date.today()).cost;

      final int moneyofMonth = moneySummary - costMonth;

      final List<Account> todayData = value.accountsData.getAccountsToday();
      String todayMoneyStr = "";
      if (todayData.isEmpty) {
        todayMoneyStr = 'No data\n';
      } else {
        int incomeToday = 0;
        int costToday = 0;
        for (var e in todayData) {
          incomeToday += e.isPositive ? e.amount : 0;
          costToday += e.isPositive ? 0 : e.amount;
        }
        todayMoneyStr = "+$incomeToday\$  $costToday\$";
      }

      final int expectedCost =
          value.accountsData.getExpectedMoneyAtDay(Date.today());
      //todayMoneyStr += "Expected cost money: $expectedCost";

      final IncomeAndCost monthlySummaryIC =
          value.accountsData.getIncomeAndCostAtMonth(Date.today());
      final String monthlySummaryStr =
          "+${monthlySummaryIC.income}\$  ${monthlySummaryIC.cost}\$  Δ ${monthlySummaryIC.income + monthlySummaryIC.cost}\$";

      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  children: [AutoSizeText(value.accountName)],
                ),
              ),
              Expanded(
                flex: 8,
                child: isPortrait
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              "$moneySummary\$",
                              style: TextStyle(fontSize: 72),
                              maxLines: 1,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Today's data:"),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 8, right: 8),
                                      child: AutoSizeText(
                                        todayMoneyStr,
                                        style: TextStyle(fontSize: 48),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                  Text("Expected cost today:"),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 8, right: 8),
                                      child: AutoSizeText(
                                        '$expectedCost\$',
                                        style: TextStyle(fontSize: 48),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              "$moneySummary\$",
                              style: TextStyle(fontSize: 72),
                              maxLines: 1,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Today's data:"),
                                Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: AutoSizeText(
                                    todayMoneyStr,
                                    style: TextStyle(fontSize: 48),
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Expected cost today:"),
                                Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: AutoSizeText(
                                    '$expectedCost\$',
                                    style: TextStyle(fontSize: 48),
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
              Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      AutoSizeText(
                          "${-costMonth}/$moneyofMonth\$ remaining : ${moneyofMonth + costMonth}\$"),
                    ],
                  )),
              LinearProgressIndicator(
                value: (moneyofMonth == 0)
                    ? 0
                    : (moneyofMonth + costMonth) / moneyofMonth,
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            ],
          ),
        ),
      );
    });
  }
}
