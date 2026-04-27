import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mobisen_app/widget/loading_empty_view.dart';
import 'package:mobisen_app/widget/mixed_list/mixed_list_item.dart';
import 'package:mobisen_app/widget/mixed_list/mixed_list_item_helper.dart';
import 'package:mobisen_app/widget/mixed_list/bottom_mixed_list_item.dart';

class MixedListView extends StatefulWidget {
  final bool bottomNavPadding;
  final Function(ScrollController controller)? onScroll;
  final bool loading;
  final bool error;
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onLoadMore;
  final List<Object>? dataRaw;
  final List<MixedListItem>? data;

  const MixedListView(
      {super.key,
      this.bottomNavPadding = false,
      this.onScroll,
      this.loading = false,
      this.error = false,
      this.onRefresh,
      this.onLoadMore,
      this.data,
      this.dataRaw});

  @override
  State<MixedListView> createState() => _MixedListViewState();
}

class _MixedListViewState extends State<MixedListView> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.onScroll != null) {
      _scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    widget.onScroll?.call(_scrollController);
  }

  @override
  Widget build(BuildContext context) {
    final finalData =
        widget.data ?? MixedListItemHelper.convertList(widget.dataRaw ?? []);
    final List<Widget> items = [];
    for (var item in finalData) {
      items.addAll(item.buildWidgets(context));
    }
    if (widget.bottomNavPadding) {
      items.addAll(BottomMixedListItem().buildWidgets(context));
    }
    return SmartRefresher(
        enablePullDown: widget.onRefresh != null,
        enablePullUp: widget.onLoadMore != null,
        header: const MaterialClassicHeader(),
        controller: _refreshController,
        onRefresh: () async {
          final refresh = widget.onRefresh ?? _loadDelay;
          await Future.wait([
            refresh(),
            _loadDelay(),
          ]);
          _refreshController.refreshCompleted();
        },
        onLoading: () async {
          final onLoadMore = widget.onLoadMore ?? _loadDelay;
          await Future.wait([
            onLoadMore(),
            _loadDelay(),
          ]);
          _refreshController.loadComplete();
        },
        child: finalData.isEmpty
            ? LoadingEmptyView(
                loading: widget.loading,
                error: widget.error,
                onRefresh: widget.onRefresh,
              )
            : CustomScrollView(
                controller: _scrollController,
                slivers: items,
              ));
  }

  Future<void> _loadDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
