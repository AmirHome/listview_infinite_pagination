import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'initial_loader.dart';
import 'load_more_loader.dart';
import 'on_empty.dart';
import 'on_error.dart';
import 'on_finished.dart';

/// Signature for a function that returns a Future List of type 'T' i.e. list
/// of items in a particular page that is being asynchronously called.
///
/// Used by [Pagination] widget.
typedef DataFetcherPagination<T> = Future<List<T>> Function(int currentListSize);

/// Signature for a function that creates a widget for a given item of type 'T'.
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
  final DataFetcherPagination<T> dataFetcher;

  /// Called to build children for [Pagination]
  ///
  /// Function should return a widget
  final ItemWidgetBuilder<T> itemBuilder;

  /// Scroll direction of list view
  final Axis scrollDirection;

  /// Builds an error widget when [dataFetcher] throws.
  final Widget Function(Object error)? onError;

  /// Displays when the first page has no data.
  final Widget onEmpty;

  /// Displays when a later page fetch returns no data.
  final Widget onFinished;

  /// Widget shown during the first fetch.
  final Widget initialLoader;

  /// Widget shown while loading additional items.
  final Widget loadMoreLoader;

  /// Whether to reverse the list order.
  final bool reverse;

  /// Scroll controller used by this list view.
  final ScrollController? controller;

  /// Whether this scroll view is the primary scroll view in the parent.
  final bool? primary;

  /// Scroll physics applied to the list view.
  final ScrollPhysics? physics;

  /// Whether the extent of the scroll view should be determined by content.
  final bool shrinkWrap;

  /// Whether this widget should wrap content with [Scaffold].
  final bool wrapWithScaffold;

  final EdgeInsetsGeometry? padding;
  final double? itemExtent;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;

  /// Pull To Refresh Indicator
  final bool toRefresh;
  final bool addSemanticIndexes;
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
    this.shrinkWrap = false,
    this.wrapWithScaffold = false,
    this.toRefresh = false,
    this.padding,
    this.itemExtent,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.semanticChildCount,
  });

  @override
  State<ListviewInfinitePagination> createState() => ListviewInfinitePaginationState<T>();
}

class ListviewInfinitePaginationState<T> extends State<ListviewInfinitePagination<T>> {
  List<T> _items = [];
  int _page = 0;
  bool _initFetchLoading = false;
  bool _moreFetchLoading = false;
  bool _lastPage = false;
  bool _isEmpty = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    _items = [];
    _page = 0;
    _initFetchLoading = false;
    _moreFetchLoading = false;
    _lastPage = false;
    _isEmpty = false;
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
    final content = Column(
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
                  !_lastPage &&
                  !_isEmpty) {
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
                    child: _isEmpty ? _buildEmptyView() : _buildListView(),
                  )
                : (_isEmpty ? _buildEmptyView() : _buildListView()),
          ),
        ),

        /// start load more loading data
        if (_moreFetchLoading) widget.loadMoreLoader,

        /// show on finished widget
        if (_lastPage) widget.onFinished,
        if (_error != null) widget.onError?.call(_error!) ?? const OnError(),
      ],
    );

    if (widget.wrapWithScaffold) {
      return Scaffold(body: content);
    }

    return content;
  }

  Widget _buildEmptyView() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: 200,
        child: Center(child: widget.onEmpty),
      ),
    );
  }

  ListView _buildListView() {
    return ListView.builder(
      padding: widget.padding,
      controller: widget.controller,
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
      List<T> fetchedItems = <T>[];
      try {
        _error = null;
        fetchedItems = await widget.dataFetcher(_page);
      } catch (error) {
        _error = error;

        /// when debug mode print error in console
        if (kDebugMode) {
          print('Something went wrong');
        }
      }

      if (!mounted) {
        return;
      }

      setState(() {
        if (_error == null) {
          /// First page empty => show empty state.
          if (fetchedItems.isEmpty && _page == 1) {
            _isEmpty = true;
            _lastPage = false;
            _items = [];
          } else {
            _isEmpty = false;

            /// Later page empty => reached end of data.
            if (fetchedItems.isEmpty) {
              _lastPage = true;
            }

            /// Add items to list
            if (init) {
              _items = fetchedItems;
            } else {
              _items.addAll(fetchedItems);
            }
          }
        }

        /// Stop loading
        _initFetchLoading = false;
        _moreFetchLoading = false;
      });
    }
  }
}
