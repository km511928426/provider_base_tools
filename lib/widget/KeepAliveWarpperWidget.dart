/*
 * @Author: cheng
 * @Version: 1.0
 * @Date: 2023-05-29 09:42:07
 * @LastEditors: cheng
 * @LastEditTime: 2023-05-29 09:43:29
 * @FilePath: \provider_base_tools\lib\widget\KeepAliveWarpperWidget.dart
 * @ObjectDescription: 页面状态保持
 */

import 'package:flutter/material.dart';

class KeepAliveWarpperWidget extends StatefulWidget {
  final bool keepAlive; // * 是否保持状态
  final Widget child; // * 包裹的widget
  const KeepAliveWarpperWidget(
      {required this.child, this.keepAlive = true, super.key});

  @override
  State<KeepAliveWarpperWidget> createState() => _KeepAliveWarpperWidgetState();
}

class _KeepAliveWarpperWidgetState extends State<KeepAliveWarpperWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  void didUpdateWidget(covariant KeepAliveWarpperWidget oldWidget) {
    if (oldWidget.keepAlive != widget.keepAlive) {
      // keepAlive 状态需要更新，实现在 AutomaticKeepAliveClientMixin 中
      updateKeepAlive();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}
