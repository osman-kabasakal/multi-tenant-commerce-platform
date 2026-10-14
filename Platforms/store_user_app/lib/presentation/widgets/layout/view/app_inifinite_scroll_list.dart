import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../skeletons/widgets/widgets.dart';

enum InfiniteScrollDirection { horizontal, vertical }

class AppInifiniteScrollList extends StatefulHookConsumerWidget {
  final InfiniteScrollDirection scrollDirection;
  final bool isLoading;
  final bool hasMore;
  final List<Widget>? items;
  final int? itemCount;
  final Future<void> Function() onLoadMore;
  final Widget Function(BuildContext context, int index)? itemBuilder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;
  final Widget Function(BuildContext context)? errorBuilder;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final double? itemExtend;
  final ScrollController? controller;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final Future<void> Function()? refresh;

  AppInifiniteScrollList({
    required super.key,
    this.scrollDirection = InfiniteScrollDirection.vertical,
    required this.isLoading,
    required this.hasMore,
    required this.onLoadMore,
    this.itemCount,
    this.items,
    this.itemBuilder,
    this.loadingBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.padding,
    this.height,
    this.itemExtend,
    this.width,
    this.controller,
    this.shrinkWrap = false,
    this.physics,
    this.refresh,
  }) : assert(itemBuilder == null || items == null || items.isEmpty,
            'itemBuilder must be null when items is not empty');

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppInifiniteScrollListState();
}

class _AppInifiniteScrollListState extends ConsumerState<AppInifiniteScrollList>
    with AutomaticKeepAliveClientMixin {
  late ScrollController scrollController;
  late int absoluteItemCount;
  late bool isEmpty;
  @override
  void initState() {
    super.initState();
    scrollController = widget.controller ?? ScrollController();
    absoluteItemCount = widget.itemCount ?? widget.items?.length ?? 0;
    isEmpty = (widget.itemCount == 0 && (widget.items?.isEmpty ?? true));
    scrollController.addListener(scrollListerner);
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListerner);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AppInifiniteScrollList oldWidget) {
    absoluteItemCount = widget.itemCount ?? widget.items?.length ?? 0;
    var oldWidgetAbsoluteItemCount =
        oldWidget.itemCount ?? oldWidget.items?.length ?? 0;
    if (oldWidgetAbsoluteItemCount > absoluteItemCount) {
      lastLoadedScroll = 0.0;
      scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    }
    super.didUpdateWidget(oldWidget);
  }

  void scrollListerner() {
    if (!widget.isLoading && widget.hasMore) {
      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.position.pixels;
      final delta = 200.0;

      if (maxScroll - currentScroll <= delta &&
          currentScroll > lastLoadedScroll) {
        lastLoadedScroll = maxScroll;
        widget.onLoadMore().then((_) {
          Future.delayed(Duration(milliseconds: 100), () {
            if (mounted) {
              setState(() {});
            }
          });
        }).then((s) {});
      }
    }
  }

  double lastLoadedScroll = 0.0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    absoluteItemCount = widget.itemCount ?? widget.items?.length ?? 0;
    isEmpty = (widget.itemCount == 0 && (widget.items?.isEmpty ?? true));

    if (widget.isLoading && isEmpty) {
      return SizedBox(
        height: widget.height,
        width: widget.width,
        child: ListView.builder(
          controller: scrollController,
          shrinkWrap: widget.shrinkWrap,
          scrollDirection:
              widget.scrollDirection == InfiniteScrollDirection.horizontal
                  ? Axis.horizontal
                  : Axis.vertical,
          itemCount: 5,
          itemBuilder: (context, index) => buildLoadingItem(),
        ),
      );
    }

    if (isEmpty) {
      return buildEmptyState();
    }

    Widget listView = ListView.builder(
      key: PageStorageKey(
          '$widget.key-infinite-scroll-list-$widget.scrollDirection'),
      controller: scrollController,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics ??
          (widget.refresh != null ? AlwaysScrollableScrollPhysics() : null),
      padding: widget.padding,
      scrollDirection:
          widget.scrollDirection == InfiniteScrollDirection.horizontal
              ? Axis.horizontal
              : Axis.vertical,
      itemCount: widget.hasMore ? absoluteItemCount + 1 : absoluteItemCount,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      itemExtent: widget.itemExtend,
      itemBuilder: (context, index) {
        if (index >= absoluteItemCount) {
          return buildLoadingItem();
        }

        if (widget.itemBuilder != null) {
          return RepaintBoundary(
            child: widget.itemBuilder!(context, index),
          );
        }

        return RepaintBoundary(child: widget.items![index]);
      },
    );

    if (widget.refresh != null) {
      listView = RefreshIndicator(
        onRefresh: widget.refresh!,
        color: context.theme.primaryColor,
        child: listView,
      );
    }

    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: listView,
    );
  }

  Widget buildLoadingItem() {
    if (widget.loadingBuilder != null) {
      return widget.loadingBuilder!(context);
    }

    return SkeletonListView(
      itemCount: 5,
      scrollable: false,
      padding: const EdgeInsets.all(8),
    );
  }

  Widget buildEmptyState() {
    if (widget.emptyBuilder != null) {
      return widget.emptyBuilder!(context);
    }
    if (widget.refresh != null) {
      return RefreshIndicator(
        onRefresh: widget.refresh!,
        color: context.theme.primaryColor,
        child: CustomScrollView(slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: Text(
                'Kayıt bulunamadı!',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ]),
      );
    }
    return Center(
      child: Text(
        'Kayıt bulunamadı!',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Widget buildErrorState() {
    if (widget.errorBuilder != null) {
      return widget.errorBuilder!(context);
    }

    return Center(
      child: Text(
        'Bir hata oluştu!',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.red,
            ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
