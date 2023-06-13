/*
 * @Author: cheng
 * @Version: 1.0
 * @Date: 2023-03-21 10:34:26
 * @LastEditors: cheng
 * @LastEditTime: 2023-06-13 10:03:55
 * @FilePath: \provider_base_tools\lib\provider\provider_base_widget.dart
 * @ObjectDescription: Provider封装 (基类)
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:provider_base_tools/interface/base_widget.dart';

import '../base/base_argment_model.dart';
import '../base/base_model.dart';
import '../interface/custom_floating_action_button_location.dart';
import '../utils/context_list.dart';
import '../utils/one_context.dart';

typedef CancelAsync = void Function();

// * 返回最顶部的BaseArgmentModel。   用于获取页面传递的参数
// * listener: 在方法里面调用该方法时，listener为false，否则会报错
T getBaseArgementModel<T extends BaseArgementModel>(
        {BuildContext? context, bool listener = true}) =>
    Provider.of<T>(context ?? OneContext.getInstance.context, listen: listener);

// * 构建页面的函数类型
typedef BuilderFunc<T> = Widget Function(
    BuildContext context, T value, Widget? child);

// * 异步方法的函数类型
typedef VoidAsyncFunction = Future<void> Function();

// * 异步回调函数
// typedef AsyncTFunction<T extends BaseModel> = Future Function(T);

// * 同步回调函数
// typedef TFunction<T extends BaseModel, S> = Function(T, S);

// * 定义Widget的函数类型
typedef ProviderWidgetBuilder = Widget Function(BuildContext context);

class BaseNoneState {}

//************************* Provider封装 *************************//

//*****************************************  StatelessWidget  *****************************************
// * 抽象StateLessWidget  私有化避免外部直接使用
abstract class _BaseStatelessWidget<T extends BaseModel>
    extends SingleChildStatelessWidget {
  const _BaseStatelessWidget({super.key});

  // * 构建body`
  @protected
  ProviderWidgetBuilder _onBodyBuiler();

  // * 是否需要Scaffold(头部) true:默认 _onBaseScaffoldBuilder生效  false: _onBaseScaffoldBuilder不生效
  // bool get showScaffold => true;

  // * 是否显示默认Scaffold的widget true:默认 onScaffoldBuilder生效(可重写改方法自定义Scaffold)  false: onScaffoldBuilder不生效
  // bool get showBaseScaffold => true;

  @override
  Widget buildWithChild(BuildContext context, Widget? child) =>
      _onBodyBuiler().call(context);

  BuildContext get context {
    _InitBaseStateLessElement.context = null;
    assert(() {
      if (ContextList.getInstance.contextList.isEmpty) {
        throw FlutterError(
          'This widget has been unmounted, so the State no longer has a context (and should be considered defunct). \n'
          'Consider canceling any active work during "dispose" or using the "mounted" getter to determine if the State is still active.',
        );
      }
      return true;
    }());
    return _InitBaseStateLessElement.context ??=
        ContextList.getInstance.contextList.last;
    // return ContextList.getInstance.contextList.last;
  }

  @override
  SingleChildStatelessElement createElement() {
    return _InitBaseStateLessElement(this);
  }
}

class _InitBaseStateLessElement extends SingleChildStatelessElement {
  _InitBaseStateLessElement(_BaseStatelessWidget widget) : super(widget) {
    context = this;
    ContextList.getInstance.addItem(this);
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    context = this;
    super.mount(parent, newSlot);
  }

  @override
  void update(covariant StatelessWidget newWidget) {
    super.update(newWidget);
    context = this;
  }

  @override
  void unmount() {
    context = null;
    ContextList.getInstance.removeItem();
    OneContext.getInstance.childContext = null;
    super.unmount();
  }

  static BuildContext? context;
}

// * 混入 避免多重继承(只能是_BaseWidget类和其子类使用)
mixin _GetDataLoading<T extends BaseModel, S> on _BaseStatelessWidget<T> {
  T getModel(); // * 获取model
  BuildContext get childContext => OneContext.getInstance.haschildContext
      ? OneContext.getInstance.childContext!
      : _findChild(context) == null
          ? _findChild(ContextList.getInstance.contextList[
              ContextList.getInstance.contextList.length <= 15
                  ? 0
                  : ContextList.getInstance.contextList.length - 2])!
          : _findChild(context)!;

  // * 递归查找当前widiget的子widget是否为Consumer<T>，如果是则返回子widget的context
  BuildContext? _findChild(BuildContext context) {
    if (context.mounted &&
        OneContext.getInstance.childContext?.widget is! Consumer<T>) {
      context.visitChildElements((element) {
        if (element.widget is Consumer<T>) {
          OneContext.getInstance.childContext = element;
          return;
        } else {
          OneContext.getInstance.childContext = _findChild(element);
        }
      });
      return OneContext.getInstance.childContext;
    }
    return OneContext.getInstance.childContext;
  }

  T get model {
    BuildContext? childContext = _findChild(context);
    if (childContext == null || childContext.mounted != true) {
      throw ('context is null');
    }
    return childContext.read<T>();
  }

  S get state {
    return model.state;
  }

  @protected
  Widget getChild(BuildContext context) => Container();

  // @protected
  // void onReady(T model, S state); // * 构建时的同步操作

  @protected
  void finish(); // * 页面销毁前的处理

  // * 默认自定义头部 (可自行定义)  {}里面可以自定义拓展字段
  @protected
  Widget getScaffold(
    BuildContext context,
    Widget? child, {
    Key? key, // * 标识key
    String title = '', // * 标题
    Color textColor = Colors.black, // * 标题颜色
    double? textSize, // * 标题字体大小
    int? textLines, // * 标题最大行数
    FontWeight? textWeight, // * 标题字体粗细
    TextAlign textAlign = TextAlign.start, // * 标题对齐方式
    String? textFamily, // * 标题字体
    double? textScaleFactor, // * 标题缩放比例
    Widget? backGroundWidget, // * 背景widget
    Color backGroundColor = Colors.white, // * 背景颜色
    bool showBack = true, // * 是否显示返回按钮
    Widget? leftWidget, // * 左边widget
    Color lefIconColor = Colors.white, // * 左边图标颜色
    Function()? leftWidgetOnTap, // * 左边widget点击事件
    Widget? titleWidget, // * 标题widget
    List<Widget>? rightWidgets, // * 右边widget
    Widget? floatingActionButton, // * 悬浮按钮
    Color appBarColor = Colors.blueAccent, // * 头部颜色
    bool showAppBar = true, // * 是否显示头部
    bool centerTitle = true, // * 标题是否居中
    bool resizeToAvoidBottomInset = true, // * 是否自动调整大小
    bool automaticallyImplyLeading = true, // * 是否自动实现返回按钮
    Widget? filexibleSpace, // * 可折叠的空间
    PreferredSizeWidget? bottom, // * 头部底部
    bool isBackGroundTransparent = false, // * 背景是否透明
    Color? shadowColor, // * 阴影颜色
    double? elevation, // * 阴影高度
    ShapeBorder? shapeBorder, // * 头部形状
    // BoxFit fit = BoxFit.fitWidth, // * 背景图片填充方式
    double? flexibleWidth, // * 可折叠的宽度
    double? flexibleHeight, // * 可折叠的高度
    bool isShowTitle = true, // * 是否显示标题
    DragStartBehavior drawerDragStartBehavior =
        DragStartBehavior.start, // * 抽屉拖动行为
    Color? drawerScrimColor, // * 抽屉遮罩颜色
    double? drawerEdgeDragWidth, // * 抽屉边缘拖动宽度
    bool drawerEnableOpenDragGesture = true, // * 抽屉是否可以拖动
    bool endDrawerEnableOpenDragGesture = true, // * 右抽屉是否可以拖动
    Widget? drawer, // * 抽屉
    Widget? endDrawer, // * 右抽屉
    Function(bool)? onDrawerChanged, // * 抽屉状态改变回调
    Function(bool)? onEndDrawerChanged, // * 右抽屉状态改变回调
    bool primary = true, // * 是否是主页面
    bool extendBody = false, // * 是否延伸body
    bool extendBodyBehindAppBar = false, // * 是否延伸body到头部
    Widget? bottomSheet, // * 底部弹出
    Widget? bottomNavigationBar, // * 底部导航栏
    CustomFloatingActionButtonLocation? location, // * 悬浮按钮位置
  }) {
    final leading = showBack
        ? leftWidget == null
            ? IconButton(
                onPressed: () {
                  leftWidgetOnTap ?? Navigator.of(context).pop();
                },
                icon: Icon(
                  CupertinoIcons.back,
                  color: lefIconColor,
                ))
            : InkWell(
                onTap: leftWidgetOnTap?.call(),
                child: leftWidget,
              )
        : null;
    return Stack(
      children: [
        Positioned.fill(
          child: backGroundWidget ?? const SizedBox(),
        ),
        Positioned.fill(
          child: Scaffold(
            key: key,
            backgroundColor:
                isBackGroundTransparent ? Colors.transparent : backGroundColor,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset, //输入框抵住键盘
            appBar: showAppBar
                ? AppBar(
                    elevation: elevation,
                    excludeHeaderSemantics: isBackGroundTransparent,
                    automaticallyImplyLeading: automaticallyImplyLeading,
                    backgroundColor: isBackGroundTransparent
                        ? Colors.transparent
                        : appBarColor,
                    flexibleSpace: filexibleSpace
                    // ??
                    //     FlexibleSpaceBar(
                    //       background: BaseWidgetImageHelper.asset(
                    //           BaseWidgetImageHelper.BASE_HEAD_BG,
                    //           width: widget.flexibleWidth,
                    //           height: widget.flexibleHeight,
                    //           fit: widget.fit),
                    //     )
                    ,
                    shape: shapeBorder,
                    title: isShowTitle
                        ? Text(
                            title,
                            textScaleFactor: textScaleFactor,
                            style: TextStyle(
                              fontSize: textSize,
                              color: textColor,
                              fontWeight: textWeight,
                              fontFamily: textFamily,
                            ),
                            textAlign: textAlign,
                            overflow: TextOverflow.ellipsis,
                            maxLines: textLines,
                          )
                        : titleWidget,
                    centerTitle: centerTitle,
                    leading: leading,
                    actions: rightWidgets ?? [],
                    bottom: bottom,
                    shadowColor: isBackGroundTransparent
                        ? Colors.transparent
                        : shadowColor,
                  )
                : null,
            floatingActionButton: floatingActionButton,
            floatingActionButtonLocation: location,
            drawer: drawer,
            endDrawer: endDrawer,
            drawerDragStartBehavior: drawerDragStartBehavior,
            primary: primary,
            extendBody: extendBody,
            extendBodyBehindAppBar: extendBodyBehindAppBar,
            drawerEdgeDragWidth: drawerEdgeDragWidth,
            drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
            drawerScrimColor: drawerScrimColor,
            endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
            onDrawerChanged: onDrawerChanged,
            onEndDrawerChanged: onEndDrawerChanged,
            bottomSheet: bottomSheet,
            bottomNavigationBar: bottomNavigationBar,
            body: child,
          ),
        ),
      ],
    );
  }

  // * 成功 Widget
  @protected
  Widget successedBuilder(BuildContext context);

  // * 加载 widget
  @protected
  Widget loadingBuilder(BuildContext context) {
    return BaseWidget.getInstance.loadingWidget.call(
      context,
    );
  }

  // * 失败 widget
  @protected
  Widget errorBuilder(BuildContext context) {
    return BaseWidget.getInstance.errorWidget.call(
      context,
      model,
    );
  }

  // * 空白 widget
  @protected
  Widget emptyBuilder(
    BuildContext context,
  ) {
    return BaseWidget.getInstance.emptyWidget.call(
      context,
    );
  }
}

// * StatelessWidget基类 (提供给外部继承的抽象类)
abstract class InitBaseStatelessWidget<T extends BaseModel, S>
    extends _BaseStatelessWidget<T> with _GetDataLoading<T, S> {
  const InitBaseStatelessWidget({
    super.key,
  });

// * 是否需要Scaffold(头部)
// * true(默认): getScaffold生效(可重写改方法,自定义Scaffold,传需要的参数进去,通过super重载直接修改值)
// * false:     getScaffold不生效(需要在_onBodyBuilder里面重写Scaffold)
  bool get showScaffold => true;

  @override
  ProviderWidgetBuilder _onBodyBuiler() => (context) => _ProviderBaseWidget(
        builder: (context, model, child) {
          OneContext.getInstance.childContext == null
              ? OneContext.getInstance.childContext = context
              : null;
          if (model.viewState == ViewState.loading) {
            return showScaffold
                ? getScaffold(context, loadingBuilder(context))
                : loadingBuilder(context);
          } else if (model.viewState == ViewState.error) {
            return showScaffold
                ? getScaffold(context, errorBuilder(context))
                : errorBuilder(context);
          } else if (model.viewState == ViewState.none) {
            return showScaffold
                ? getScaffold(context, emptyBuilder(context))
                : emptyBuilder(context);
          } else {
            return showScaffold
                ? getScaffold(context, successedBuilder(context))
                : successedBuilder(context);
          }
        },
        model: context.watch<T?>() ?? getModel.call(),
        // onModelReadyAsync: (value) async => await onReadyAsyc(value),
        // onModelReady: (T value, S state) => onReady(value, state),
        finish: () => finish,
        child: getChild(context),
      );
}

// //*****************************************  分割线  *****************************************

// * 自定义监听
ValueNotifier<T> create<T extends BaseModel>(T value) =>
    ValueNotifier<T>(value);

//**        构建整个provider页面的基类  私有化避免外部直接使用
// * builder       构建页面
// * model         传入model
// * child         传入子组件
// * onModelReady  在页面加载完成后，调用model中的方法(这个回调是个同步,所以不需要等待页面构建完成,可以直接同步进行网络请求或者一些异步操作处理)
// * loading       显示加载中的页面
// * error         显示错误页面
// * none          显示空页面
// */
class _ProviderBaseWidget<T extends BaseModel, S>
    extends SingleChildStatefulWidget {
  final BuilderFunc builder;
  final T model;
  // final AsyncTFunction<T>? onModelReadyAsync;
  // final TFunction<T, S>? onModelReady;
  final Function() finish;
  final Widget? child;

  const _ProviderBaseWidget({
    Key? key,
    required this.builder,
    required this.model,
    required this.finish,
    // this.onModelReady,
    // this.onModelReadyAsync,
    this.child,
  }) : super(key: key);

  @override
  State<_ProviderBaseWidget<T, S>> createState() =>
      _ProviderBaseWidgetState<T, S>();
}

class _ProviderBaseWidgetState<T extends BaseModel, S>
    extends SingleChildState<_ProviderBaseWidget<T, S>> {
  // * 延时初始化,避免在构造函数中初始化
  late T model;

  @override
  void initState() {
    model = widget.model;

    // * 如果有传入onModelReady,则调用 (这个回调是个同步,所以不需要等待页面构建完成,可以直接同步进行网络请求或者一些同步操作处理)
    // if (widget.onModelReady != null) {
    //   // * 初始化后调用同步步方法 (比如初始化一些需要的控制器等等) (异步的操作可以全部放在model里面通过自定义异步方法来实现)
    //   widget.onModelReady?.call(
    //     model,
    //     model.state,
    //   );
    // * 初始化后调用异步方法
    // Future.sync(() async => model).then((value) async => await _init(model));
    // }

    super.initState();
  }

  // * 异步
  // Future _init(T model) async =>
  //     await widget.onModelReady?.call(model, model.state);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) =>
      // widget.builder(context, model, child);
      // Consumer<T>(
      //       builder: widget.builder,
      //       child: Container(
      //         width: 100,
      //         height: 100,
      //         color: Colors.yellowAccent,
      //       ),
      //     );
      ChangeNotifierProvider<T>(
        create: (BuildContext context) => model,
        child: Consumer<T>(
          builder: widget.builder,
          child: widget.child,
        ),
      );

  @override
  void dispose() {
    widget.finish();
    OneContext.getInstance.childContext = null;
    super.dispose();
  }
}
