import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact List',
      theme: ThemeData(
        primaryColor: Colors.teal[400],
      ),
      home: ContactPage(title: 'CONTACTS'),
    );
  }
}

class ContactPage extends StatefulWidget {
  ContactPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Future<List<User>> _getUsers() async {
    var uri = Uri.parse('https://reqres.in/api/users?per_page=12');
    var response = await http.get(uri);

    List<User> users = [];
    if (response.statusCode == 200) {
      Map<String, dynamic> map = convert.jsonDecode(response.body);
      List<dynamic> data = map["data"];
      print(data[0]["first_name"]);
      for (var u in data) {
        User user = User(u["id"], u["email"],
            u["first_name"] + " " + u["last_name"], u["avatar"]);
        users.add(user);
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return users;
  }

  int _selectedIndex = -1;

  Color _getSelectedTextColor(int index) {
    return _selectedIndex == index ? Colors.white : Colors.black;
  }

  List<Widget> _getIcon(int index) {
    var wids = <Widget>[];
    if (_selectedIndex != index) {
      wids.add(Icon(
        Icons.circle,
        color: index == 4 ? Colors.red : Colors.green,
        size: 18,
      ));
      return wids;
    }

    wids.add(Icon(
          Icons.phone,
          color: Colors.white,
        ));

    wids.add(SizedBox(width: 15));

    wids.add(Icon(
          Icons.chat_bubble_outline_outlined,
          color: Colors.white,
        ));

    return wids;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: Text(widget.title, style: TextStyle(letterSpacing: 2.0),),
        centerTitle: true,
        toolbarHeight: MediaQuery.of(context).size.width * 0.2,
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text('Loading...'),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      textDirection: TextDirection.ltr,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: 100.0,
                          decoration: BoxDecoration(
                            image: new DecorationImage(
                              fit: BoxFit.cover,
                              colorFilter: index == _selectedIndex
                                  ? null
                                  : ColorFilter.mode(
                                      Colors.purple.withOpacity(0.6),
                                      BlendMode.multiply),
                              image: new NetworkImage(
                                snapshot.data[index].avatar,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              height: 100.0,
                              padding: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                  color: index == _selectedIndex
                                      ? Colors.purple[100]
                                      : index.toInt() % 2 != 0
                                          ? Colors.grey[100]
                                          : Colors.white),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                textDirection: TextDirection.ltr,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        textDirection: TextDirection.ltr,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data[index].fullName,
                                            style: TextStyle(
                                                color: _getSelectedTextColor(
                                                    index),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            snapshot.data[index].email,
                                            style: TextStyle(
                                                color: _getSelectedTextColor(
                                                    index),
                                                fontSize: 14.0),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        textDirection: TextDirection.ltr,
                                        children: _getIcon(index),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        )
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add Contact',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class User {
  final int id;
  final String email;
  final String fullName;
  final String avatar;

  User(this.id, this.email, this.fullName, this.avatar);
}
