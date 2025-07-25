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
                  title: Text('#${item.id} ${item.title}'),
                  subtitle: Text('${item.body!} - index $index'),
                ),
              ],
            ),
          );
        },
        dataFetcher: (page) => dataFetchApi(page),

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

Future<List<Post>> dataFetchApi(int page) async {
  const String baseUrl = 'https://jsonplaceholder.typicode.com/posts';
  List<Post> testList = [];

  try {
    final res = await http.get(
      Uri.parse("$baseUrl?_page=$page&_limit=10&_sort=id&_order=desc"),
      headers: {
        'User-Agent': 'Mozilla/5.0',
        'Accept': 'application/json',
      },
    );

    if (res.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(res.body);
      testList = jsonList.map((post) => Post.fromJson(post)).toList();
    } else {
      print('Error: Status Code ${res.statusCode}');
      print('Response: ${res.body}');
    }
  } catch (e) {
    
    ('Exception occurred: $e');
  }

  return testList;
}