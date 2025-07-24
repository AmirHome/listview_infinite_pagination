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

Future<List<Post>> dataFetchApi(int page, [String sortQuery='id']) async {
  const String baseUrl = 'https://jsonplaceholder.typicode.com/posts';
  List<Post> testList = [];

  try {
    final res = await http.get(
      Uri.parse("$baseUrl?_page=$page&_limit=10&_sort=$sortQuery&_order=desc"),
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
    print('Exception occurred: $e');
  }

  return testList;
}
