import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repetitions_app/screens/admin_repetitions_screen.dart';
import 'package:repetitions_app/screens/user_repetitions_screen.dart';
import '../variables/my_colors.dart';

import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  Widget buildListTile(String title, IconData icon, Function action) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
        color: myColors.tertiary,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'RobotoCondesed',
          fontSize: 20,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      ),
      onTap: action,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool _isAuth = Provider.of<Auth>(context, listen: true).isAuth;
    bool _isAdmin =
        Provider.of<Auth>(context, listen: false).userRole == 0 ? true : false;

    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Menu'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          buildListTile('Courses', Icons.menu_book, () {
            Navigator.of(context).pushReplacementNamed('/');
          }),
          if(_isAuth) const Divider(),
          _isAuth
              ? _isAdmin
                  ? buildListTile('Lessons', Icons.edit_calendar, () {
                      Navigator.of(context).pushReplacementNamed(
                          AdminRepetitionsScreen.routeName);
                    })
                  : buildListTile('My Lessons', Icons.edit_calendar, () {
                      Navigator.of(context).pushReplacementNamed(
                          UserRepetitionsScreen.routeName);
                    })
              : const Center(),
          const Divider(),
          buildListTile(_isAuth ? 'Logout' : 'Login',
              _isAuth ? Icons.exit_to_app : Icons.login, () {
            Navigator.of(context).pop();
            Navigator.of(context)
                .pushReplacementNamed('/'); //mostriamo la home screen
            Provider.of<Auth>(context, listen: false).logout();
          }),
        ],
      ),
    );
  }
}
