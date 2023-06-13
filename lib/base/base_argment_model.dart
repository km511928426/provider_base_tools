import '../provider/provider_base_widget.dart';
import 'base_model.dart';

abstract class BaseArgementModel extends BaseModel<BaseNoneState> {
  BaseArgementModel.getInstance(super.initial) : super.getInstance();

  @override
  bool get dataIsEmpty => false;

  @override
  List<VoidAsyncFunction> initFutures() {
    return [];
  }
}
