import 'package:flutter/material.dart';

class PlatformSelectionPage extends StatefulWidget {
  @override
  _PlatformSelectionPageState createState() => _PlatformSelectionPageState();
}

class _PlatformSelectionPageState extends State<PlatformSelectionPage> {
  List platforms = ['Android', 'iOS'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Platform Selection'),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemCount: platforms.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.mobile_screen_share),
            title: Text(platforms[index]),
            onTap: () {},
          );
        },
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }
}
