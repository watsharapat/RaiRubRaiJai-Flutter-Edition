import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/account_provider.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> listViewData = <Widget>[
      Consumer<User>(builder: (context, value, child) {
        List<Widget> listTiles = <Widget>[];
        for (var e in value.accountList) {
          listTiles.add(
            ListTile(
              title: Text(e),
              onTap: () {
                value.selectAccountName(e);
                Navigator.pop(context);
              },
              leading: const Icon(Icons.account_balance_wallet),
            ),
          );
        }
        return ListView(
          shrinkWrap: true,
          children: listTiles,
        );
      })
    ];

    //? show list of account

    return Drawer(
      child: Column(
        children: [
          Container(
              color: Theme.of(context).primaryColor,
              height: 200,
              child: Center(
                  child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Consumer<User>(
                  builder: (context, value, child) {
                    return Expanded(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundImage:
                                NetworkImage(value.user!.photoUrl!),
                          ),
                          Flexible(
                              child: Text(
                            value.user!.email,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            overflow: TextOverflow.ellipsis,
                          )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.account_balance_wallet,
                                  color: Colors.white),
                              Flexible(
                                child: Text(
                                  value.accountName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ))),
          Expanded(flex: 5, child: ListView(children: listViewData)),
          ListTile(
            title: const Text('Quick income titles'),
            onTap: () {
              //? alert dialog with text field
              Navigator.pop(context);
              Navigator.pushNamed(context, '/edit_quick', arguments: true);
            },
            leading: const Icon(Icons.monetization_on),
          ),
          ListTile(
            title: const Text('Quick cost titles'),
            onTap: () {
              //? alert dialog with text field
              Navigator.pop(context);
              Navigator.pushNamed(context, '/edit_quick', arguments: false);
            },
            leading: const Icon(Icons.money_off),
          ),
          ListTile(
            title: const Text('create new account'),
            onTap: () {
              //? alert dialog with text field
              var _controller = TextEditingController();
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Create new account'),
                    content: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Account name',
                        ),
                        onChanged: (value) {}),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          User pData =
                              Provider.of<User>(context, listen: false);
                          pData.addAccount(_controller.text);
                        },
                        child: Text('Create'),
                      ),
                    ],
                  );
                },
              );
            },
            leading: const Icon(Icons.add),
          ),
          ListTile(
            title: Consumer<User>(builder: (context, value, child) {
              return Text('rename account (${value.accountName})');
            }),
            onTap: () {
              //? alert dialog with text field
              User pData = Provider.of<User>(context, listen: false);
              var _controller = TextEditingController(text: pData.accountName);
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Rename from ${_controller.text}'),
                    content: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'new account name',
                        ),
                        onChanged: (value) {}),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          User pData =
                              Provider.of<User>(context, listen: false);
                          pData.renameCurrentAccount(_controller.text);
                        },
                        child: Text('rename'),
                      ),
                    ],
                  );
                },
              );
            },
            leading: const Icon(Icons.edit),
          ),
          Consumer<User>(
            builder: (context, value, child) {
              return ListTile(
                title: Text('remove account (${value.accountName})'),
                onTap: () {
                  //? alert dialog with confirmation
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Remove ${value.accountName}'),
                        content: Text(
                            'Are you sure you want to remove ${value.accountName}'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              User pData =
                                  Provider.of<User>(context, listen: false);
                              pData.removeCurrentAccount();
                            },
                            child: Text('Remove'),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                leading: const Icon(Icons.delete),
                enabled: value.accountList.length > 1,
              );
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Logout...please wait'),
                    content: Container(
                      width: 100,
                      height: 100,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                },
                barrierDismissible: false,
              );

              User pData = Provider.of<User>(context, listen: false);
              pData.doLogout().then((value) => Navigator.of(context)
                  .pushNamedAndRemoveUntil(
                      '/', (Route<dynamic> route) => false));
            },
            leading: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
