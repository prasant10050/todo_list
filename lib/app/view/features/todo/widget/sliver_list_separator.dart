import 'dart:math' as math;

import 'package:flutter/material.dart';

class SliverListSeparator extends StatelessWidget {
  const SliverListSeparator({
    required this.builder,
    required this.separator,
    required this.childCount,
    super.key,
    this.padding = EdgeInsets.zero,
    this.addAutomaticKeepAlive = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.findChildIndexCallback,
    this.semanticIndexOffset = 0,
  });

  final Widget? Function(BuildContext context, int index) builder;
  final Widget separator;
  final EdgeInsetsGeometry padding;
  final int childCount;
  final bool addAutomaticKeepAlive;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final ChildIndexGetter? findChildIndexCallback;
  final int semanticIndexOffset;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding,
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final itemIndex = index ~/ 2;
            if (index.isOdd) return separator;
            return builder(context, itemIndex);
          },
          childCount: math.max(0, childCount * 2 - 1),
          addAutomaticKeepAlives: addAutomaticKeepAlive,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          findChildIndexCallback: findChildIndexCallback,
          semanticIndexOffset: semanticIndexOffset,
        ),
      ),
    );
  }
}
