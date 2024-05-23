import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data_model/date.dart';
import '../../provider/account_provider.dart';
import '../../widget/bottom_bar.dart';
import 'home_list.dart';
import 'home_card.dart';
import 'home_drawer.dart';
import '../../util.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget tileData(String title, String subtitle) {
    return Card(
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 36.0)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 24.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var today = DateTime.now();

    String todayStr = " ${getMonthName(today.month)} ${today.year}";
    return Scaffold(
      drawer: const HomeDrawer(),
      appBar: AppBar(
        title: Consumer<User>(
          builder: (context, value, child) {
            return Text('Account: ${value.accountName}');
          },
        ),
        actions: [
          //? Refresh Button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<User>(context, listen: false).refreshAccount();
            },
          ),
        ],
      ),
      body: const Column(
        children: <Widget>[
          //? Info data
          Expanded(
            flex: 1,
            child: Padding(padding: EdgeInsets.all(8), child: HomeCard()),
          ),
          //Display Today Data
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: TodayDataList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(focused: BottomPages.home),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/addData', arguments: Date.today());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
