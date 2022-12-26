import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:listview_infinite_pagination/listview_infinite_pagination.dart';

import 'package:http/http.dart' as http;

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
        title: const Text('Flutter Demo'),
      ),
      body: ListviewInfinitePagination<Post>(
        itemBuilder: (index, item) {
          return Container(
            color: Colors.yellow,
            height: 48,
            child: Text('$index => ${item.title}'),
          );
        },
        dataFetcher: (page) => dataFetchApi(page),
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
  const String _baseUrl = 'https://jsonplaceholder.typicode.com/posts';
  List<Post> testList = [];

  try {
    final res = await http.get(Uri.parse("$_baseUrl?_page=$page&_limit=10"));
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
