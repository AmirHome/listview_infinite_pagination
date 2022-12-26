import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'initial_loader.dart';
import 'load_more_loader.dart';
import 'on_empty.dart';
import 'on_finished.dart';
import 'on_error.dart';

/// Signature for a function that returns a Future List of type 'T' i.e. list
/// of items in a particular page that is being asynchronously called.
///
/// Used by [Pagination] widget.
typedef DataFetcherPagination<T> = Future<List<T>> Function(
    int currentListSize);

/// Signature for a function that creates a widget for a given item of type 'T'.
// typedef ItemWidgetBuilder<T> = Widget Function(int index, T item);
typedef ItemWidgetBuilder<T> = Widget Function(int index, T item);

/// A scrollable view list which implements pagination.
///
/// When scrolled to the end of the list [Pagination] calls [dataFetcher] which
/// must be implemented which returns a Future List of type 'T'.
///
/// [itemBuilder] creates widget instances on demand.
class ListviewInfinitePagination<T> extends StatefulWidget {
  /// Called when the list scrolls to an end
  ///
  /// Function should return Future List of type 'T'
  final DataFetcherPagination<T> dataFetcher; //dataFetch

  /// Called to build children for [Pagination]
  ///
  /// Function should return a widget
  final ItemWidgetBuilder itemBuilder;

  /// Scroll direction of list view
  final Axis scrollDirection;

  /// Handle error returned by the Future implemented in [dataFetcher]
  final Function(dynamic error)? onError;

  /// Handle error returned by the Future implemented in [dataFetcher]
  final Widget? onEmpty;

  /// Handle error returned by the Future implemented in [dataFetcher]
  final Widget onFinished;

  /// When non-null [progress] widget is called to show loading progress
  final Widget initialLoader;

  /// When non-null [progress] widget is called to show loading progress
  final Widget loadMoreLoader;

  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap = false;
  final EdgeInsetsGeometry? padding;
  final double? itemExtent;
  final bool addAutomaticKeepAlives = true;
  final bool addRepaintBoundaries = true;
  final bool addSemanticIndexes = true;
  final double? cacheExtent;
  final int? semanticChildCount;

  /// Creates a scrollable, paginated, linear array of widgets.
  ///
  /// The arguments [dataFetcher], [itemBuilder] must not be null.
  const ListviewInfinitePagination({
    Key? key,
    required this.dataFetcher,
    required this.itemBuilder,
    this.initialLoader = const InitialLoader(),
    this.loadMoreLoader = const LoadMoreLoader(),
    this.onError,
    this.onEmpty = const OnEmpty(),
    this.onFinished = const OnFinished(),
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.padding,
    this.itemExtent,
    this.cacheExtent,
    this.semanticChildCount,
    // super.key,
    // super.scrollDirection,
    // super.reverse,
    // super.controller,
    // super.primary,
    // super.physics,
    // super.shrinkWrap,
    // super.padding,
    // this.itemExtent,
    // this.prototypeItem,
    // bool addAutomaticKeepAlives = true,
    // bool addRepaintBoundaries = true,
    // bool addSemanticIndexes = true,
    // super.cacheExtent,
    // List<Widget> children = const <Widget>[],
    // int? semanticChildCount,
    // super.dragStartBehavior,
    // super.keyboardDismissBehavior,
    // super.restorationId,
    // super.clipBehavior,
  }) : super(key: key);

  get scrollController => null;

  @override
  State<ListviewInfinitePagination> createState() =>
      _ListviewInfinitePagination();
}

class _ListviewInfinitePagination<T>
    extends State<ListviewInfinitePagination<T>> {
  final List<T> _items = [];
  int _page = 0;
  bool _initFetchLoading = false;
  bool _moreFetchLoading = false;
  bool _lastPage = false;

  // late ScrollController _scrollController;

  @override
  void initState() {
    _moreFetch();
    // Set up a scroll controller to listen for scroll events
    // _scrollController = widget.scrollController ?? ScrollController();
    super.initState();
  }

/*  @override
  void didChangeDependencies() {
    // _scrollController = ScrollController()..addListener(moreFetch);
    // Listen to scroll events to trigger more fetch
    _scrollController.addListener(() {
      var nextPageTrigger = _scrollController.position.maxScrollExtent;
      // If we are at the end of the list, fetch more items
      if (_scrollController.position.pixels == nextPageTrigger && !_moreFetchLoading && !_lastPage) {
        moreFetch();
      }
    });
    super.didChangeDependencies();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _initFetchLoading
            ? widget.initialLoader
            : Column(
                children: [
                  // start initial loading data
                  if (_initFetchLoading) widget.initialLoader,
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification is ScrollEndNotification &&
                              notification.metrics.extentAfter == 0 &&
                              !_moreFetchLoading &&
                              !_lastPage) {
                            _moreFetch();
                          }
                          return true;
                        },
                        child: ListView.builder(
                          padding: widget.padding,
                          // controller: _scrollController,
                          physics: widget.physics,
                          primary: widget.primary,
                          reverse: widget.reverse,
                          shrinkWrap: widget.shrinkWrap,
                          itemExtent: widget.itemExtent,
                          cacheExtent: widget.cacheExtent,
                          addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
                          addRepaintBoundaries: widget.addRepaintBoundaries,
                          addSemanticIndexes: widget.addSemanticIndexes,
                          scrollDirection: widget.scrollDirection,
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
                            // if (index < _items.length) {
                            return widget.itemBuilder(index, _items[index]);
                            // }
                            return const SizedBox();
                          },
                        )),
                  ),
                  // start load more loading data
                  if (_moreFetchLoading) widget.loadMoreLoader,
                  if (_lastPage) widget.onFinished,
                ],
              ));
  }

  void _moreFetch() {
    if (!_moreFetchLoading && !_initFetchLoading) {
      // Next page Increase _page by 1
      _page += 1;

      // Control Initial
      setState(() {
        // Start loading
        _initFetchLoading = (_page == 1);
        // Display a progress indicator at the bottom of the list
        _moreFetchLoading = !_initFetchLoading;
      });

      widget.dataFetcher(_page).then((list) {
        setState(() {
          // Stop loading
          _initFetchLoading = false;
          _moreFetchLoading = false;
        });
        // Check if last page
        if (list.isEmpty) {
          setState(() => _lastPage = true);
        }
        // Add new items
        setState(() => _items.addAll(list));
      }).catchError((error) {
        setState(() {
          // Stop loading
          _initFetchLoading = false;
          _moreFetchLoading = false;
          // _lastPage = false;
        });

        if (widget.onError != null) {
          widget.onError!(error);
        }
      });
    }
  }
}
