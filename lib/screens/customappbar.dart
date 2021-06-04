import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarText;
  List<Widget> icons = [];

  CustomAppBar(this.appBarText);
  CustomAppBar.withIcons(this.appBarText, this.icons);

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    Padding homeScreenIcon = Padding(
        padding: EdgeInsets.all(12.0),
        child: GestureDetector(
            onTap: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
            child: Icon(Icons.home)));
    icons.insert(0, homeScreenIcon);

    return AppBar(
      centerTitle: true,
      title: Text(
        appBarText,
      ),
      actions: icons,
    );
  }
}
