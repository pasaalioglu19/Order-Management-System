import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomDrawer extends StatefulWidget {
  final VoidCallback? homeOnTap;
  final VoidCallback? profileOnTap;
  final String currentPage;

  const CustomDrawer({
    Key? key,
    this.homeOnTap,
    this.profileOnTap,
    required this.currentPage,
  }) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late String currentPage;

  @override
  void initState() {
    currentPage = widget.currentPage;
  }

  Color getTileColor(String page) {
    return currentPage == page
        ? const Color.fromARGB(255, 244, 243, 191)
        : Colors.transparent;
  }

  Widget buildListTile(String title, IconData icon, VoidCallback? onTap) {
    return ListTile(
      tileColor: getTileColor(title),
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }

  Future<void> _confirmSignOut() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Dismiss the dialog
                await FirebaseAuth.instance.signOut();
              },
              child: Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFE2DFC3),
      child: ListView(
        children: [
          const SizedBox(height: 80.0),
          buildListTile('Home', Icons.home, () {
            setState(() {
              currentPage = 'Home';
            });
            if (widget.homeOnTap != null) {
              widget.homeOnTap!();
            }
          }),
          buildListTile('Profile', Icons.person, () {
            setState(() {
              currentPage = 'Profile';
            });
            if (widget.profileOnTap != null) {
              widget.profileOnTap!();
            }
          }),
          buildListTile('Logout', Icons.logout, () {
            setState(() {
              currentPage = 'Logout';
            });
            _confirmSignOut(); // Show the logout confirmation dialog
          }),
        ],
      ),
    );
  }
}
