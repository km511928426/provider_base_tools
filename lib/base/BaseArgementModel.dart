import '../provider/ProviderBaseWidget.dart';
import 'BaseModel.dart';

abstract class BaseArgementModel extends BaseModel<BaseNoneState> {
  BaseArgementModel.getInstance(super.initial) : super.getInstance();

  @override
  bool get dataIsEmpty => false;

  @override
  List<VoidAsyncFunction> initFutures() {
    return [];
  }
}
