/// Lazy loading utilities for lists
library lazy_loading;

import 'package:flutter/widgets.dart';

/// Lazy list view that loads items as needed
class LazyListView<T> extends StatefulWidget {
  /// Creates a lazy list view
  const LazyListView({
    required this.items,
    required this.itemBuilder,
    this.loadMoreThreshold = 3,
    this.onLoadMore,
    this.isLoading = false,
    this.hasMore = false,
    this.loadingWidget,
    this.emptyWidget,
    this.separatorBuilder,
    super.key,
  });

  /// List of items to display
  final List<T> items;
  
  /// Builder for each item
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  
  /// Number of items from end to trigger load more
  final int loadMoreThreshold;
  
  /// Callback when more items should be loaded
  final Future<void> Function()? onLoadMore;
  
  /// Whether currently loading
  final bool isLoading;
  
  /// Whether there are more items to load
  final bool hasMore;
  
  /// Widget to show while loading
  final Widget? loadingWidget;
  
  /// Widget to show when list is empty
  final Widget? emptyWidget;
  
  /// Builder for separator between items
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  @override
  State<LazyListView<T>> createState() => _LazyListViewState<T>();
}

class _LazyListViewState<T> extends State<LazyListView<T>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.maxScrollExtent == 0 || !position.hasPixels) return;

    final threshold = position.maxScrollExtent - (position.viewportDimension * 0.2);

    if (position.pixels >= threshold && !widget.isLoading && widget.hasMore) {
      widget.onLoadMore?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty && !widget.isLoading) {
      return widget.emptyWidget ?? const SizedBox.shrink();
    }

    return ListView.separated(
      controller: _scrollController,
      itemCount: widget.items.length + (widget.hasMore ? 1 : 0),
      separatorBuilder: (context, index) {
        if (widget.separatorBuilder != null) {
          return widget.separatorBuilder!(context, index);
        }
        return const SizedBox.shrink();
      },
      itemBuilder: (context, index) {
        if (index < widget.items.length) {
          return widget.itemBuilder(context, widget.items[index], index);
        }

        // Loading indicator at the end
        return widget.loadingWidget ??
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
      },
    );
  }
}

/// Pagination controller for managing paginated data
class PaginationController<T> extends ChangeNotifier {
  /// Creates a pagination controller
  PaginationController({
    required this.fetchPage,
    this.pageSize = 20,
  });

  /// Function to fetch a page of data
  final Future<List<T>> Function(int page, int pageSize) fetchPage;
  
  /// Number of items per page
  final int pageSize;

  List<T> _items = [];
  int _currentPage = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;

  /// All loaded items
  List<T> get items => _items;
  
  /// Whether currently loading
  bool get isLoading => _isLoading;
  
  /// Whether there are more items to load
  bool get hasMore => _hasMore;
  
  /// Last error message
  String? get error => _error;

  /// Load the first page
  Future<void> refresh() async {
    _items.clear();
    _currentPage = 0;
    _hasMore = true;
    _error = null;
    notifyListeners();
    await loadMore();
  }

  /// Load the next page
  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newItems = await fetchPage(_currentPage, pageSize);
      
      if (newItems.isEmpty || newItems.length < pageSize) {
        _hasMore = false;
      }

      _items.addAll(newItems);
      _currentPage++;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear all data
  void clear() {
    _items.clear();
    _currentPage = 0;
    _hasMore = true;
    _error = null;
    notifyListeners();
  }
}
