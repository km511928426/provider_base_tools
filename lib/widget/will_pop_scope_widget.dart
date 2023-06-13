/*
 * @Author: cheng
 * @Version: 1.0
 * @Date: 2023-05-09 09:22:27
 * @LastEditors: cheng
 * @LastEditTime: 2023-05-29 09:38:06
 * @FilePath: \provider_base_tools\lib\widget\WillPopScopeWidget.dart
 * @ObjectDescription: 包裹的widget无法一次性退出
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WillPopScopeWidget extends StatefulWidget {
  final Widget child; // * 包裹的widget
  final bool douleClick; // * 是否双击退出
  final Object? argment; // * 返回的参数
  final WillPopCallback? onWillPop; // * 自定义点击事件
  const WillPopScopeWidget(
      {required this.child,
      this.douleClick = true,
      this.argment,
      this.onWillPop,
      super.key});

  @override
  State<WillPopScopeWidget> createState() => _WillPopScopeWidgetState();
}

class _WillPopScopeWidgetState extends State<WillPopScopeWidget> {
  //定义个变量，检测两次点击返回键的时间，如果在1秒内点击两次就退出
  DateTime? _lastPopTime;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: widget.onWillPop ??
          () async {
            if (widget.douleClick) {
              if (_lastPopTime == null ||
                  DateTime.now().difference(_lastPopTime!) >
                      const Duration(seconds: 1)) {
                _lastPopTime = DateTime.now();
                //实现toast提醒
                debugPrint('再按一次退出APP');
              } else {
                _lastPopTime = DateTime.now();
                // 退出整个APP
                await SystemChannels.platform
                    .invokeMethod('SystemNavigator.pop');
              }
            } else {
              Navigator.of(context).pop(widget.argment);
            }
            return false;
          },
      child: widget.child,
    );
  }
}
