import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/account_provider.dart';

class LogInPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LogInPage> {
  bool isLogin = false;

  @override
  void initState() {
    isLogin = true;
    User uData = Provider.of<User>(context, listen: false);
    uData.doLoginSilent().then((value) {
      if (uData.user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        isLogin = false;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Column(
            children: [
              const SizedBox(height: 40),
              Image.asset(
                'images/Wut.jpg',
                height: 280,
                width: 280,
              ),
              const SizedBox(height: 100),
              (!isLogin)
                  ? GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.only(right: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Image.asset(
                                'images/icon.png',
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            const Text(
                              'Sign-in with Google',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              width: 15,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        isLogin = true;
                        setState(() {});
                        User uData = Provider.of<User>(context, listen: false);
                        print(">>>>> LOGIN......");
                        uData.doLogin().then((value) {
                          if (uData.user != null)
                            Navigator.pushReplacementNamed(context, '/home');
                          else {
                            isLogin = false;
                            setState(() {});
                          }
                        }).onError((error, stackTrace) {
                          isLogin = false;
                          setState(() {});
                        });
                      },
                    )
                  : CircularProgressIndicator(),
            ],
          ),
        ],
      ),
    ));
  }
}
