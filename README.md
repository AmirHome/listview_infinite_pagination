# Infinite Pagination ListView Scrollable
A very lite Flutter Package infinite scroll listview with pagination.

# Platforms
This plugin has been successfully tested on iOS, Android & web.

# Examples
The following examples are extracted from the example project available in the repository. More examples are available in this project.

# Demo of infinite scroll listview with pagination

![listview_infinite_pagination](https://github.com/AmirHome/listview_infinite_pagination/blob/master/assets/demo_listview_infinite_pagination.gif)

## Features

* [x] Infinite scroll listview.
* [x] Automating Pagination
* [x] Customizable listview item widget.
* [x] Customizable listview initial loading widget.
* [x] Customizable listview more loading widget.
* [x] Customizable listview empty widget.
* [x] Customizable listview error widget.
* [x] Customizable listview when end of list is reached widget.
* [x] To Refresh listview.


## Getting started and Usage

We need to two steps to use this package.
1. First step is to create a function to fetch data to use dataFetcher function.
2. Second step is to implement and design the listview to use itemBuilder function.

### First Example Model Data Sample String List
```dart

          ListviewInfinitePagination<Post>(
            itemBuilder: (index, item) {
              return Text('$index => ${item.title}',
              );
            },
            dataFetcher: (page) => dataFetchMocha(page),
          )
          
          // ####### Data Sample Mocha Function dataFetchMocha
          Future<List<String>> dataFetchMocha(int page) async {
              List<String> testList = [];
              if (page < 4) {
                for (int i = 1 + (page - 1) * 20; i <= page * 20; i++) {
                  testList.add('Item$i of page$page');
                }
              }
              return testList;
          }
```

### Second Example Model with Data Sample Api
```dart

          ListviewInfinitePagination<Post>(
            itemBuilder: (index, item) {
              return Text('$index => ${item}');
            },
            dataFetcher: (page) => dataFetchApi(page),
          )
          
          // ####### Data Sample Api Function dataFetchApi
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
```

#### API Reference
- [Free fake API for testing and prototyping](https://jsonplaceholder.typicode.com/)

##### Get all items

```
  GET /posts
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `_page` | `int` |  Pagination |
| `_limit` | `int` |  Offset |


```
[
  { id: 1, title: '...' /* ... */ },
  { id: 2, title: '...' /* ... */ },
  { id: 3, title: '...' /* ... */ },
  /* ... */
  { id: 100, title: '...' /* ... */ },
];
```

## Additional information




# LICENSE!

Dropdown Searchable list is [MIT-licensed](https://github.com/AmirHome/listview_infinite_pagination/LICENSE "MIT-licensed").

# Let us know!

I would be happy if you send us feedback on your projects where you use our component. Just email amir.email@gmail.com  and let me know if you have any questions or suggestions about my work.