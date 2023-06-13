/*
 * @Author: cheng
 * @Version: 1.0
 * @Date: 2023-05-26 15:09:40
 * @LastEditors: cheng
 * @LastEditTime: 2023-06-13 16:33:42
 * @FilePath: \provider_base_tools\lib\base\base_none_model.dart
 * @ObjectDescription: 页面没有可交互数据时，显示baseNoneModel
 */
// 页面没有可交互数据时，显示baseNoneModel
import '../provider/provider_base_widget.dart';
import 'base_model.dart';

class BaseNoneModel extends BaseModel<BaseNoneState> {
  BaseNoneModel.getInstance(super.initial) : super.getInstance();

  @override
  bool get dataIsEmpty => false;

  @override
  List<VoidAsyncFunction> initFutures() {
    return [];
  }
}
