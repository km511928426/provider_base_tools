/*
 * @Author: cheng
 * @Version: 1.0
 * @Date: 2023-05-26 16:08:19
 * @LastEditors: cheng
 * @LastEditTime: 2023-06-06 17:02:11
 * @FilePath: \provider_base_tools\lib\interface\base_widget.dart
 * @ObjectDescription: 
 */
import 'package:flutter/material.dart';
import 'package:provider_base_tools/provider_base_tools.dart';

class BaseWidget {
  static final BaseWidget _instance = BaseWidget._();

  static BaseWidget get getInstance {
    return _instance;
  }

  BaseWidget._();

  // * 加载动画
  Widget Function(BuildContext context) loadingWidget =
      (context) => const Center(
            child: CircularProgressIndicator(),
          );

  // * 默认错误页面
  Widget Function(BuildContext context, BaseModel model) errorWidget =
      (BuildContext context, BaseModel model) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  '加载失败',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    model.refresh();
                  },
                  child: const Text('重新加载'),
                ),
              ],
            ),
          );

  // * 空白 widget
  Widget Function(BuildContext context) emptyWidget = (context) => const Center(
        child: Text('页面为空'),
      );
}
