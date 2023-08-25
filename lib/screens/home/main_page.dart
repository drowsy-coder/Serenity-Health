import 'package:serenity/constants.dart';
import 'package:serenity/widgets/drawers/user_profile_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _page = 0;
  String _title = 'Home';

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
      if (page == 0) {
        _title = 'Home';
      } else if (page == 1) {
        _title = 'Toolbox';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          _title,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: false,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: CircleAvatar(
                backgroundImage: NetworkImage(
                  FirebaseAuth.instance.currentUser?.photoURL ?? '',
                ),
              ),
              onPressed: () => displayEndDrawer(context),
            ),
          ),
        ],
      ),
      body: Constants.tabWidgets[_page],
      endDrawer: AppDrawer(),
      bottomNavigationBar: CupertinoTabBar(
        activeColor: Colors.amber,
        backgroundColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.safety_check), label: ''),
        ],
        onTap: onPageChanged,
        currentIndex: _page,
      ),
    );
  }
}
