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
      final List<Account> todayData = value.accountsData.getAccountsToday();
      int moneySummary =
          value.accountsData.getAccumulatedBeforeDay(Date.today());

      for (var e in todayData) {
        moneySummary += e.isPositive ? 0 : e.amount;
      }

      final int costMonth =
          value.accountsData.getIncomeAndCostAtMonth(Date.today()).cost;

      final int moneyofMonth = moneySummary - costMonth;

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
        todayMoneyStr = "+$incomeToday  $costToday";
      }

      final int expectedCost =
          value.accountsData.getExpectedMoneyAtDay(Date.today());
      //todayMoneyStr += "Expected cost money: $expectedCost";

      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                flex: 8,
                child: isPortrait
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(children: [
                            const Text("Remaining"),
                            Expanded(
                              child: AutoSizeText(
                                "$moneySummary\ ",
                                style: const TextStyle(fontSize: 72),
                                maxLines: 1,
                              ),
                            ),
                          ]),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Today's summary"),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      child: AutoSizeText(
                                        todayMoneyStr,
                                        style: const TextStyle(fontSize: 48),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                  const Text("Expected cost per day:"),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      child: AutoSizeText(
                                        '$expectedCost',
                                        style: const TextStyle(fontSize: 48),
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
                              "$moneySummary",
                              style: const TextStyle(fontSize: 72),
                              maxLines: 1,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Today's data:"),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: AutoSizeText(
                                    todayMoneyStr,
                                    style: const TextStyle(fontSize: 48),
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
                                const Text("Expected cost today:"),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: AutoSizeText(
                                    '$expectedCost',
                                    style: const TextStyle(fontSize: 48),
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
                          "${-costMonth}/$moneyofMonth remaining : ${moneyofMonth + costMonth}"),
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
