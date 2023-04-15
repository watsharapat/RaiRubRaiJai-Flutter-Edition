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
      drawer: HomeDrawer(),
      appBar: AppBar(
        title: Consumer<User>(
          builder: (context, value, child) {
            return Text('รายรับรายจ่าย : ${value.accountName}');
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
      body: Column(
        children: const <Widget>[
          //? Info data
          Expanded(
            flex: 3,
            child: Padding(padding: EdgeInsets.all(10), child: HomeCard()),
          ),
          //Display Today Data
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: TodayDataList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomAppBar(
        child: BottomNavigation(focused: BottomPages.home),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/addData', arguments: Date.today());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
