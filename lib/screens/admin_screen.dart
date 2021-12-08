import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:best_flutter_ui_templates/design_course/design_course_app_theme.dart';

import '../model/users.dart';
import '../widget/users_info.dart';

class Adminprofile extends StatelessWidget {
  // static const routeName = '/user-products';

  Future<void> _refresh(BuildContext context) async {
    Provider.of<Users>(context, listen: false).fetchAndSetUsers();
  }

  @override
  Widget build(BuildContext context) {
    final usersData = Provider.of<Users>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: DesignCourseAppTheme.nearlyBlack //change your color here
            ),
        backgroundColor: DesignCourseAppTheme.nearlyBlue,
        title: Text(
          'Users',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            letterSpacing: 0.27,
            color: Colors.black,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: usersData.items.length,
            itemBuilder: (_, i) => Column(
              children: [
                UserInfo(
                  usersData.items[i].userid,
                  usersData.items[i].email,
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
