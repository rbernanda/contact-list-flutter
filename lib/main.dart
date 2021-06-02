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
        primarySwatch: Colors.green,
      ),
      home: ContactPage(title: 'Contacts'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text('Loading'),
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
                            color: Colors.purple[100],
                            image: new DecorationImage(
                              fit: BoxFit.cover,
                              colorFilter: index == _selectedIndex ? null : ColorFilter.mode(
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
                                        children: <Widget>[
                                          Icon(
                                            Icons.phone,
                                            color: Colors.black,
                                          ),
                                          SizedBox(width: 15),
                                          Icon(
                                            Icons.chat_bubble_outline_outlined,
                                            color: Colors.black,
                                          )
                                        ],
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

// return ListTile(
//                     leading: ConstrainedBox(
//                         constraints: BoxConstraints(
//                           minWidth: 44,
//                           minHeight: 100,
//                           maxWidth: 64,
//                           maxHeight: 100,
//                         ),

//                         child: Image.network(snapshot.data[index].avatar, fit: BoxFit.cover)),
//                     title: Text(
//                       snapshot.data[index].fullName,
//                       style: TextStyle(
//                           color: _getSelectedTextColor(index),
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18.0),
//                     ),
//                     subtitle: Text(snapshot.data[index].email,
//                         style: TextStyle(
//                             color: _getSelectedTextColor(index),
//                             fontSize: 14.0)),
//                             contentPadding:
//                         EdgeInsets.all(0),
//                     // contentPadding:
//                     //     EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
// tileColor: index.toInt() % 2 != 0
//     ? Colors.grey[100]
//     : Colors.white,
// onTap: () {
//   setState(() {
//     _selectedIndex = index;
//   });
// },
//                     selected: index == _selectedIndex,
//                     selectedTileColor: Colors.purple[100],
//                   );
