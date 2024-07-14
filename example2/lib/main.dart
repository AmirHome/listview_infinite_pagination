import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:listview_infinite_pagination/listview_infinite_pagination.dart';

// Create a new Dart file in model folder and name it post.dart
// Copy the following code in bottom of this file
import 'model/post.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortQuery = 'id';

  final GlobalKey<ListviewInfinitePaginationState<Post>> _paginationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        backgroundColor: Colors.amber,
        title: const Text('Demo Listview Infinite Pagination', style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.sort),
                  onSelected: (String value) {
                    setState(() {
                      _sortQuery = value;
                    });
                    _paginationKey.currentState?.reset();
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'id',
                      child: Text('ID'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'title',
                      child: Text('Title'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListviewInfinitePagination<Post>(
              key: _paginationKey,
              itemBuilder: (index, item) {
                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.image, size: 45),
                        title: Text('#${item.id} ${item.title}'),
                        subtitle: Text('${item.body!} - index $index'),
                      ),
                    ],
                  ),
                );
              },
              dataFetcher: (page) => dataFetchApi(page, _sortQuery),

              // ######## Optional ########
              /// If you want to refresh and reset the listview
              toRefresh: true,

              /// If you want to show a custom error widget
              // onError: (dynamic error) => Center(
              //   child: Text(error.toString()),
              // ),

              /// If you want to show a custom empty widget
              // onEmpty: const Center(
              //   child: Text('This is empty'),
              // ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<List<String>> dataFetch(int page) async {
  await Future.delayed(const Duration(seconds: 0, milliseconds: 2000));
  List<String> testList = [];
  if (page < 4) {
    for (int i = 1 + (page - 1) * 20; i <= page * 20; i++) {
      testList.add('Item$i in page$page');
    }
  }
  return testList;
}

Future<List<Post>> dataFetchApi(int page, [String sortQuery=''] ) async {
  const String baseUrl = 'https://jsonplaceholder.typicode.com/posts';
  List<Post> testList = [];

  final res = await http.get(Uri.parse("$baseUrl?_page=$page&_limit=10&_sort=$sortQuery&_order=desc"));
  json.decode(res.body).forEach((post) {
    testList.add(Post.fromJson(post));
  });

  return testList;
}

/*
* Create a new Dart file in model folder and name it post.dart
class Post {
  int? _userId;
  int? _id;
  String? _title;
  String? _body;

  Post({int? userId, int? id, String? title, String? body}) {
    if (userId != null) {
      this._userId = userId;
    }
    if (id != null) {
      this._id = id;
    }
    if (title != null) {
      this._title = title;
    }
    if (body != null) {
      this._body = body;
    }
  }

  int? get userId => _userId;
  set userId(int? userId) => _userId = userId;
  int? get id => _id;
  set id(int? id) => _id = id;
  String? get title => _title;
  set title(String? title) => _title = title;
  String? get body => _body;
  set body(String? body) => _body = body;

  Post.fromJson(Map<String, dynamic> json) {
    _userId = json['userId'];
    _id = json['id'];
    _title = json['title'];
    _body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this._userId;
    data['id'] = this._id;
    data['title'] = this._title;
    data['body'] = this._body;
    return data;
  }
}
* */
