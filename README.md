<!--
 * @Author: cheng
 * @Version: 1.0
 * @Date: 2023-05-26 15:03:04
 * @LastEditors: cheng
 * @LastEditTime: 2023-06-13 10:19:47
 * @FilePath: \provider_base_tools\README.md
 * @ObjectDescription:  项目说明
-->
# provider_base_tools

provider_base_tools 是一个基于provider的封装，主要是为了简化provider的使用，提高开发效率。

1. ### 安装 (推荐 git 方式集成, 方便更新.  配合provider_temp_gen模板生成器使用提升开发效率)
   ```
   dependencies:
     provider_base_tools: ^0.0.7 (暂时没有发布pub仓库,现这种方式无法集成)

   provider_base_tools:
      git:
        url: https://github.com/km511928426/provider_base_tools.git  (推荐使用git方法集成)
        ref: 0.0.7
   ```
2. ### 使用

   2.1. 创建一个model类，继承BaseArgmentModel (用户页面直接传递参数)
   ```
   class TestBaseArgemnt extends BaseArgementModel {
    TestBaseArgemnt.getInstance(super.initial) : super.getInstance();
    }
   ```

   2.2. runApp方法中使用
   ```
   void main() {
        runApp(
          ChangeNotifierProvider<TestBaseArgemnt>.value(
            value: TestBaseArgemnt.getInstance(
              BaseNoneState(),
            ),
            builder: (context, child) => const MyApp(),
          ),
        );
    }
   ```

   2.3. 页面中使用
   2.3.1. 创建一个state类 用于存储数据,与view,model进行交互
   ```
    class DemoState {
     DemoState();
     }
   ```
   
   2.3.2. 创建一个model类, 继承BaseModel<T> 绑定state类
   ```
   class DemoModel extends BaseModel<DemoState> {
     DemoModel.getInstance(super.initial) : super.getInstance();

     @override
     bool get dataIsEmpty => false; // * 页面显示状态根据此值判断
     
     @override
     List<VoidAsyncFunction> initFutures() { // * 所有的初始化异步方法 (例如:第一次进来的网络请求)
       return [];
     }
   }
   ```

   2.3.3. 创建一个view类,继承InitBaseStatelessWidget<T,S> 绑定model与state类
   ```
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
   ```

3. ### 说明
   
   | 类名 | 说明 |
   | - | - |
   | BaseArgementModel | 用于页面传递参数 |
   | BaseModel | 用于存储数据,与view,model进行交互 |
   | BaseNoneModel | 提供页面不需要model交互的公共类 |
   | BaseNoneState | 提供页面不需要state交互的公共类 |
   | InitBaseStatelessWidget | 用于创建页面 |
   | BaseWidget | 用于定义默认布局 |
   | GetLefeCycleMixin | 自定义生命周期 (暂未完善) |
   | ProviderSingleTickerProviderStateMixin | 自定义单个TickerProvider (方便model使用TickerProviderStateMixin,初始化ticker对象) |
   | ProviderTickerProviderStateMixin | 自定义多个个TickerProvider (方便model使用TickerProviderStateMixin,初始化ticker对象) |
   | CustomFloatingActionButtonLocation | 自定义FloatingActionButtonLocation位置 |
   | KeepAliveWarpperWidget | 状态保活页面 |
   | WillPopScopeWidget | 对于WillPopScope的封装 |
   | ContextList | Context的栈堆管理 (一般适用于框架,开发中用不到这个类,可无视) |
   | OneContext | 用于获取context |

   # OneContext 
   | 方法名 | 说明 |
   | - | - |
   | context | 返回当前页面的全局context |
   | childContext | 返回当前Provider的context |

   # BaseModel
   | 方法名 | 说明 |
   | - | - |
   | dataIsEmpty | 页面显示状态根据此值判断 |
   | exception | 捕获的异常信息 |
   | state | 返回State对象 |
   | viewState | 页面显示状态 |
   | setState() | 通知页面刷新 |
   | initFutures | 所有的初始化异步方法 (例如:第一次进来的网络请求) |
   | refresh() | 刷新页面 |
   | setLoading() | 设置页面状态为加载中 |
   | setSuccess() | 设置页面状态为加载成功 |
   | setError() | 设置页面状态为加载失败 |
   | setEmpty() | 设置页面状态为加载空 |

   # InitBaseStatelessWidget
   | 方法名 | 说明 |
   | - | - |
   | getModel() | 返回Model对象 (调用此方法会重新走model构造方法) |
   | childContext | 返回当前Provider的context |
   | context | 返回当前页面的全局context |
   | model | 返回Model对象 |
   | state | 返回State对象 |
   | onReady() | 进入build之前的回调 (已移除) |
   | finish() | 页面销毁 |
   | successedBuilder() | 页面加载成功的布局 |
   | loadingBuilder() | 页面加载中的布局 |
   | errorBuilder() | 页面加载失败的布局 |
   | emptyBuilder() | 页面加载空的布局 |
   | getScaffold() | 返回一个Scaffold对象 (自定Scaffold,可根据参数注释自定义) |
   | showScaffold | 是否需要Scaffold (默认true) |
    
   # BaseWidget
   | 方法名 | 说明 |
   | - | - |
   | loadingWidget | 默认加载中的布局 (可自定义) |
   | errorWidget | 默认加载失败的布局 (可自定义) |
   | emptyWidget | 默认加载空的布局 (可自定义) |

