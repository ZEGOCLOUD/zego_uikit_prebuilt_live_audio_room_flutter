// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

const layoutGridItemIndexKey = "grid_index";

/// layout config of grid
class ZegoLayoutGridConfig extends ZegoLayout {
  /// whether to display rounded corners and spacing between views
  double? borderRadius;
  double? layoutPadding;
  double? itemPadding;
  final int fixedRow;
  final int fixedColumn;
  final Color? backgroundColor;

  ZegoLayoutGridConfig({
    required int fixedRow,
    required int fixedColumn,
    this.borderRadius,
    this.layoutPadding,
    this.itemPadding,
    this.backgroundColor,
  })  : fixedRow = fixedRow < 1 ? 1 : fixedRow,
        fixedColumn = fixedColumn < 1 ? 1 : fixedColumn,
        super.internal();
}

/// picture in picture layout
class ZegoLayoutGrid extends StatefulWidget {
  const ZegoLayoutGrid({
    Key? key,
    required this.userList,
    required this.layoutConfig,
    this.usersItemIndex = const {},
    this.foregroundBuilder,
    this.backgroundBuilder,
  }) : super(key: key);

  final List<ZegoUIKitUser> userList;
  final Map<String, int> usersItemIndex; //  map<user id, item index>
  final ZegoLayoutGridConfig layoutConfig;

  final ZegoAudioVideoViewForegroundBuilder? foregroundBuilder;
  final ZegoAudioVideoViewBackgroundBuilder? backgroundBuilder;

  @override
  State<ZegoLayoutGrid> createState() => _ZegoLayoutGridState();
}

class _ZegoLayoutGridState extends State<ZegoLayoutGrid> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var users = List<ZegoUIKitUser?>.from(widget.userList);

    /// fill empty cell
    var totalCount =
        widget.layoutConfig.fixedRow * widget.layoutConfig.fixedColumn;
    if (users.length < totalCount) {}
    for (int diff = totalCount - users.length; diff > 0; diff--) {
      users.add(null);
    }

    /// swap users if specify the user cell index
    widget.usersItemIndex.forEach((targetUserID, targetItemIndex) {
      var targetUserCurrentIndex =
          users.indexWhere((user) => user?.id == targetUserID);
      if (-1 == targetUserCurrentIndex) {
        return;
      }

      if (targetUserCurrentIndex != targetItemIndex) {
        var targetUser = users[targetUserCurrentIndex];
        users[targetUserCurrentIndex] = users[targetItemIndex];
        users[targetItemIndex] = targetUser;
      }
    });

    var itemIndex = 0;
    var layoutItems = users.map((user) {
      var userID = user?.id ?? math.Random().nextInt(10000).toString();

      var audioVideoView = ZegoAudioVideoView(
        user: user,
        borderRadius: widget.layoutConfig.borderRadius,
        borderColor: Colors.transparent,
        extraInfo: {layoutGridItemIndexKey: itemIndex},
        foregroundBuilder: widget.foregroundBuilder,
        backgroundBuilder: widget.backgroundBuilder,
      );

      itemIndex = itemIndex + 1;

      return LayoutId(
        id: userID,
        child: audioVideoView,
      );
    }).toList();

    var layoutPadding = widget.layoutConfig.layoutPadding ?? 0;
    var itemPadding = widget.layoutConfig.itemPadding ?? 0;
    return Container(
      color: widget.layoutConfig.backgroundColor,
      child: CustomMultiChildLayout(
        delegate: GridLayoutDelegate.autoFill(
          autoFillItems: layoutItems,
          columnCount: widget.layoutConfig.fixedColumn,
          lastRowAlignment: GridLayoutAlignment.start,
          layoutPadding: Size(layoutPadding, layoutPadding),
          itemPadding: Size(itemPadding, itemPadding),
        ),
        children: layoutItems,
      ),
    );
  }
}
