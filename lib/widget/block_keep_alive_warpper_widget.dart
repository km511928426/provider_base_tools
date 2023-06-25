/*
 * @Author: cheng
 * @Version: 1.0
 * @Date: 2023-06-25 14:11:56
 * @LastEditors: cheng
 * @LastEditTime: 2023-06-25 14:12:09
 * @FilePath: \provider_base_tools\lib\widget\block_keep_alive_warpper_widget.dart
 * @ObjectDescription: 不往上传递保持状态的通知
 */
import 'package:flutter/material.dart';

class BlockKeepAliveWrapper extends StatefulWidget {
  const BlockKeepAliveWrapper({required this.child, super.key});

  final Widget child;
  @override
  State<BlockKeepAliveWrapper> createState() => _BlockKeepAliveWrapperState();
}

class _BlockKeepAliveWrapperState extends State<BlockKeepAliveWrapper> {
  late Widget _child;

  @override
  void initState() {
    super.initState();
    _updateChild();
  }

  @override
  void didUpdateWidget(BlockKeepAliveWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateChild();
  }

  void _updateChild() {
    _child = NotificationListener<KeepAliveNotification>(
      onNotification: _block,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _block(KeepAliveNotification notification) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return _child;
  }
}
