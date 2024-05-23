import 'package:flutter/material.dart';
import '../pages/all_main_page.dart';

enum BottomPages { home, edit, setting }

class BottomNavigation extends StatelessWidget {
  final BottomPages focused;
  const BottomNavigation({required this.focused, super.key});

  Widget _buildBottomNavigationItem(context,
      {required IconData icon,
      required BottomPages name,
      required String text,
      void Function()? onTap}) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              icon,
              color: focused == name
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).unselectedWidgetColor,
              size: 30.0,
            ),
            onPressed: onTap,
            padding: const EdgeInsets.all(8),
          ),
          Text(text, style: const TextStyle(fontSize: 12.0)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      //color: StyleData.backgroundSecondaryColor,
      elevation: 100, // ความสูงของ shadow
      height: 88, // ความสูงของ BottomAppBar
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBottomNavigationItem(
            context,
            icon: Icons.home,
            name: BottomPages.home,
            text: 'Home',
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/home');
              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => SafeArea(child: HomePage())));
            },
          ),
          _buildBottomNavigationItem(
            context,
            icon: Icons.calendar_month,
            name: BottomPages.edit,
            text: 'Edit',
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/edit');
              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SafeArea(child: CalendarPage())));
            },
          ),
          _buildBottomNavigationItem(
            context,
            icon: Icons.settings,
            name: BottomPages.setting,
            text: 'Settings',
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/setting');
              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SafeArea(child: GraphPage())));
            },
          ),
        ],
      ),
    );
  }
}
