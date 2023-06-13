/*
 * @Author: cheng
 * @Version: 1.0
 * @Date: 2023-06-13 14:27:15
 * @LastEditors: cheng
 * @LastEditTime: 2023-06-13 14:37:48
 * @FilePath: \provider_base_tools\example\lib\main.dart
 * @ObjectDescription: 
 */
import 'package:flutter/material.dart';
import 'package:provider_base_tools/provider_base_tools.dart';

class TestBaseArgemnt extends BaseArgementModel {
  TestBaseArgemnt.getInstance(super.initial) : super.getInstance();
}

void main() {
  // 自定义全局widget
  // BaseWidget.getInstance
  //   ..loadingWidget = ((context) => const Center(
  //         child: Text('重新自定义加载'),
  //       ))
  //   ..emptyWidget = ((context) => const Center(
  //         child: Text('重新自定义空白'),
  //       ))
  //   ..errorWidget = ((context, model) => const Center(
  //         child: Text('重新自定义错误'),
  //       ));
  runApp(
    ChangeNotifierProvider<TestBaseArgemnt>.value(
      value: TestBaseArgemnt.getInstance(
        BaseNoneState(),
      ),
      builder: (context, child) => const MaterialApp(
        home: DemoPage(),
      ),
    ),
  );
}

class DemoState {
  DemoState();
}

class DemoModel extends BaseModel<DemoState> {
  DemoModel.getInstance(super.initial) : super.getInstance();

  @override
  bool get dataIsEmpty => false; // 页面显示状态根据此值判断

  @override
  List<VoidAsyncFunction> initFutures() {
    // 所有的初始化异步方法 (例如:第一次进来的网络请求)
    return [];
  }
}

class DemoPage extends InitBaseStatelessWidget<DemoModel, DemoState> {
  const DemoPage({super.key});

  @override
  void finish() {}

  @override
  DemoModel getModel() {
    return DemoModel.getInstance(DemoState());
  }

  @override
  Widget successedBuilder(BuildContext context) {
    return const Center(
      child: Text('successedBuilder'),
    );
  }
}
