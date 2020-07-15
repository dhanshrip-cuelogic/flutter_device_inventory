import 'package:flutter/material.dart';
import 'SignInPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: {
        '/signinPage': (BuildContext context) => SignInPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _users = ['Admin', 'Employee'];

  void _redirectToSigninPage() {
    Navigator.pushNamed(context, '/signinPage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('HomeScreen'),
      ),
      body: Center(
        child: ListView.separated(
          itemCount: _users.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.accessibility),
              title: Text(_users[index]),
              onTap: () {
                _redirectToSigninPage();
              },
            );
          },
          separatorBuilder: (context, index) => Divider(),
        ),
      ),
    );
  }
}
