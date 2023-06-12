/*
 * @Author: cheng
 * @Version: 1.0
 * @Date: 2023-05-26 15:07:17
 * @LastEditors: cheng
 * @LastEditTime: 2023-06-05 11:52:15
 * @FilePath: \provider_base_tools\lib\base\BaseModel.dart
 * @ObjectDescription: 管理页面的状态基类
 */

// * 页面状态枚举
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../extension/GetLifeCycleMixin.dart';
import '../provider/ProviderBaseWidget.dart';

enum ViewState {
  loading,
  success,
  error,
  none,
}

// * 管理页面的状态基类
abstract class BaseModel<T> extends ChangeNotifier
    with GetLifeCycleMixin
    implements ReassembleHandler {
  // * 单例模式
  @protected
  BaseModel.getInstance(T initial) : super() {
    _setState = initial;
    _initFutures();
  }

  @override
  void reassemble() {
    debugPrint('Did hot reload!');
  }

  late final T _state;

  T get state => _state;

  set _setState(T value) => _state = value;

  final _futures = <VoidAsyncFunction>[];

  // * 保存异步方法
  @protected
  List<VoidAsyncFunction> initFutures();

  // * 判断数据是否为空
  @protected
  bool get dataIsEmpty;

  ViewState viewState = ViewState.none;

  // * 存储错误信息
  Exception? _exception;

  Exception? get exception => _exception;

  // * 一般外部不会直接调用，而是通过setState来调用
  // * 但是如果外部需要直接调用，可以通过这个方法来调用
  // ViewState get state => _state;

  // * 改变状态通知页面刷新
  void setState(void Function() fn) {
    try {
      fn();
    } finally {
      notifyListeners();
    }
  }
}

mixin BaseModelMixxin on BaseModel {}

// * 对BaseModel的扩展
extension BaseModelExtension on BaseModel {
  // * 初始化所有状态以及执行异步方法
  void _initFutures() {
    viewState = ViewState.loading;
    _futures.addAll(initFutures());
    if (_futures.isEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () => setSuccess());
    } else {
      Future.wait(_futures.map((e) async => await e.call())).then((value) {
        viewState = dataIsEmpty ? ViewState.none : ViewState.success;
        setState(() {});
      }).catchError((e, stack) {
        assert(e.toString().isNotEmpty);
        viewState = ViewState.error;
        _exception = Exception(e.toString());
        setState(() {});
        //异步抛出错误
        Future.error(e, stack);
      });
    }
  }

  // * 刷新所有数据与状态
  void refresh() {
    setLoading();
    _futures.clear();
    _initFutures();
  }

  void setLoading() => setState(() {
        viewState = ViewState.loading;
      });

  void setError() => setState(() {
        viewState = ViewState.error;
      });

  void setSuccess() => setState(() {
        viewState = ViewState.success;
      });

  void setEmpty() => setState(() {
        viewState = ViewState.none;
      });
}
