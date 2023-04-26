import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:rgd_app/pages/login.dart';
import 'package:rgd_app/pages/user/user_details.dart';
import 'package:rgd_app/pages/user/dashboard.dart';
import 'package:rgd_app/pages/user/profile.dart';
import 'package:rgd_app/utils/backgound_service.dart';

class UserMain extends StatefulWidget {
  UserMain({Key? key}) : super(key: key);

  @override
  _UserMainState createState() => _UserMainState();
}

class _UserMainState extends State<UserMain> {
  @override
  void initState() {
    super.initState();
    initService();
  }

  void initService() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await BackgroundService.initializeService();
    }
  }

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    Profile(),
    MyApp(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String text = "Stop Service";
    Color color = Colors.red;
    final email = FirebaseAuth.instance.currentUser!.email;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Welcome To RGD"),
            ElevatedButton(
              onPressed: () async {
                FlutterBackgroundService().invoke("stopService");
                await FirebaseAuth.instance.signOut();
                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                    (route) => false);
              },
              style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(flex: 9, child: _widgetOptions.elementAt(_selectedIndex)),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final service = FlutterBackgroundService();
                    print(await service.isRunning());
                    service.invoke("stopService");
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  child: const Text('Stop Alarm'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final service = FlutterBackgroundService();
                    print(await service.isRunning());
                    initService();
                    service.invoke("setAsForeground");
                    // service.startService();
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  child: const Text('Start Alarm'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'User Details',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }
}
