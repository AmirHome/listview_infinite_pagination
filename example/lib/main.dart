import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:listview_infinite_pagination/listview_infinite_pagination.dart';

import 'package:http/http.dart' as http;

// Create a new Dart file in model folder and name it post.dart
// Copy the following code in bottom of this file
import 'model/post.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        backgroundColor: Colors.amber,
        title: const Text('Demo Listview Infinite Pagination', style: TextStyle(color: Colors.black)),
      ),
      body: ListviewInfinitePagination<Post>(
        itemBuilder: (index, item) {
          return Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.image, size: 45),
                  title: Text('#$index ${item.title}'),
                  subtitle: Text(item.body!),
                ),
              ],
            ),
          );
        },
        dataFetcher: (page) => dataFetchApi(page),

        // ######## Optional ########
        onError: (dynamic error) => const Center(
          child: Text('error'),
        ),
        onEmpty: const Center(
          child: Text('This is empty'),
        ),
      ),

    );
  }
}

Future<List<String>> dataFetch(int page) async {
  await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
  List<String> testList = [];
  if (page < 4) {
    for (int i = 1 + (page - 1) * 20; i <= page * 20; i++) {
      testList.add('Item$i in page$page');
    }
  }
  return testList;
}

Future<List<Post>> dataFetchApi(int page) async {
  const String baseUrl = 'https://jsonplaceholder.typicode.com/posts';
  List<Post> testList = [];

  try {
    final res = await http.get(Uri.parse("$baseUrl?_page=$page&_limit=10"));
    json.decode(res.body).forEach((post) {
      testList.add(Post.fromJson(post));
    });
  } catch (err) {
    if (kDebugMode) {
      print('Something went wrong');
    }
  }

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