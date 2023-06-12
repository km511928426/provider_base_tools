/*
 * @Author: cheng
 * @Version: 1.0
 * @Date: 2023-05-26 15:09:40
 * @LastEditors: cheng
 * @LastEditTime: 2023-05-26 15:09:54
 * @FilePath: \provider_base_tools\lib\base\BaseNoneModel.dart
 * @ObjectDescription: 页面没有可交互数据时，显示baseNoneModel
 */
// * 页面没有可交互数据时，显示baseNoneModel
import '../provider/ProviderBaseWidget.dart';
import 'BaseModel.dart';

class BaseNoneModel extends BaseModel<BaseNoneState> {
  BaseNoneModel.getInstance(super.initial) : super.getInstance();

  @override
  bool get dataIsEmpty => false;

  @override
  List<VoidAsyncFunction> initFutures() {
    return [];
  }
}
