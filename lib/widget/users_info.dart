import 'package:best_flutter_ui_templates/model/users.dart';
import 'package:best_flutter_ui_templates/screens/admin_chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;

import '../screens/edituser_screen.dart';
import '../model/user.dart';

class UserInfo extends StatelessWidget {
  final String id;
  final String fullname;
  //final String imageUrl;
  Widget adminchat = new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(home: new AdminPage()));

  UserInfo(this.id, this.fullname);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(fullname),
      /* leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),*/
      trailing: Container(
        width: 160,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.message),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => adminchat,
                    ));
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditUserScreen.routeName, arguments: id);
              },
              /*onPressed: () {

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditUserScreen(id),
                    ));
              },*/
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  provider.Provider.of<Users>(context, listen: false)
                      .deleteUser(id);
                } catch (error) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(error.toString()),
                  ));
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
