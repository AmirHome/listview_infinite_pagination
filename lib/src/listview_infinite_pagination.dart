import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'initial_loader.dart';
import 'load_more_loader.dart';
import 'on_empty.dart';
import 'on_finished.dart';

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

  /// Pull To Refresh Indicator
  final bool toRefresh;
  final bool addSemanticIndexes = true;
  final double? cacheExtent;
  final int? semanticChildCount;

  /// Creates a scrollable, paginated, linear array of widgets.
  ///
  /// The arguments [dataFetcher], [itemBuilder] must not be null.
  const ListviewInfinitePagination({
    super.key,
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
    this.toRefresh = false,
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
  });

  get scrollController => null;

  // @override
  // State<ListviewInfinitePagination> createState() =>
  //     _ListviewInfinitePagination();

  @override
  State<ListviewInfinitePagination> createState() => ListviewInfinitePaginationState<T>();
}

class ListviewInfinitePaginationState<T> extends State<ListviewInfinitePagination<T>> {

  List<T> _items = [];
  int _page = 0;
  bool _initFetchLoading = false;
  bool _moreFetchLoading = false;
  bool _lastPage = false;
  var _error;

  // late ScrollController _scrollController;

  @override
  void initState() {
    /// Fetch first page
    // moreFetch();

    /// Set up a scroll controller to listen for scroll events
    /// _scrollController = widget.scrollController ?? ScrollController();
    super.initState();
    _initialize();
  }

  void _initialize() {
    _items = [];
    _page = 0;
    _initFetchLoading = false;
    _moreFetchLoading = false;
    _lastPage = false;
    _error = null;

    /// Fetch first page
    moreFetch();
  }

  void reset() {
    setState(() {
      _initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        /// start initial loading data
        if (_initFetchLoading) widget.initialLoader,
        Expanded(
          /// Listen to scroll events to trigger more fetch
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification &&
                  notification.metrics.extentAfter == 0 &&
                  !_moreFetchLoading &&
                  !_lastPage) {
                /// Fetch more data
                moreFetch(init: false);
              }
              return true;
            },

            /// Build ListView with items
            child: widget.toRefresh
                ? RefreshIndicator(
                    /// Fetch first page
                    onRefresh: moreFetch,
                    child: _buildListView(),
                  )
                : _buildListView(),
          ),
        ),

        /// start load more loading data
        if (_moreFetchLoading) widget.loadMoreLoader,

        /// show on finished widget
        if (_lastPage) widget.onFinished,
        if (_error != null) widget.onError!(_error),
      ],
    ));
  }

  ListView _buildListView() {
    return ListView.builder(
      padding: widget.padding,

      /// controller: _scrollController,
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

      /// Build item widget
      itemBuilder: (context, index) {
        return widget.itemBuilder(index, _items[index]);
      },
    );
  }

  Future<void> moreFetch({bool init = true}) async {
    if (!_moreFetchLoading && !_initFetchLoading) {
      /// Next page Increase _page by 1
      /// if init is true then _page = 1
      _page = init ? 1 : _page + 1;

      /// Control Initial
      setState(() {
        /// Start loading
        _initFetchLoading = (_page == 1);

        /// Display a progress indicator at the bottom of the list
        _moreFetchLoading = !_initFetchLoading;
      });

      /// Fetch data
      List<T> list = [];
      try {
        list = await widget.dataFetcher(_page);
      } catch (error) {
        _error = error;
        //setState(() => _error = error);
        /// when debug mode print error in console
        if (kDebugMode) {
          print('Something went wrong');
        }
      }

      setState(() {
        /// Check if last page
        if (list.isEmpty && _error == null) {
          setState(() => _lastPage = true);
        }

        /// Add items to list
        if (init) {
          _items = list;
        } else {
          _items.addAll(list);
        }

        /// Stop loading
        _initFetchLoading = false;
        _moreFetchLoading = false;
      });
    }
  }
}
