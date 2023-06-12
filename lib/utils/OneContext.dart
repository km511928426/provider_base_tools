import 'package:flutter/material.dart';

import 'ContextList.dart';

class OneContext {
  static final OneContext _instance = OneContext._();

  static OneContext get getInstance {
    return _instance;
  }

  OneContext._();

  // static late BuildContext? _context;

  /// The almost top root context of the app,
  /// use it carefully or don't use it directly!
  /// * 当前页面顶层context
  BuildContext get context {
    assert(ContextList.getInstance.contextList.isNotEmpty, '无法找到当前Context');
    if (!hasContext) {
      throw FlutterError(
        'This widget has been unmounted, so the State no longer has a context (and should be considered defunct). \n'
        'Consider canceling any active work during "dispose" or using the "mounted" getter to determine if the State is still active.',
      );
    }
    return ContextList.getInstance.contextList.last;
  }

  // BuildContext get aContext {
  //   assert(ContextList.getInstance.contextList.isNotEmpty, '无法找到当前Context');
  //   if (!hasContext) {
  //     throw FlutterError(
  //       'This widget has been unmounted, so the State no longer has a context (and should be considered defunct). \n'
  //       'Consider canceling any active work during "dispose" or using the "mounted" getter to determine if the State is still active.',
  //     );
  //   }
  //   return ContextList.getInstance.contextList.first;
  // }

  static bool get hasContext => ContextList.getInstance.contextList.isNotEmpty;
  // set context(BuildContext? newContext) => _context = newContext;

  // * 当前页面body的context
  BuildContext? childContext;

  bool get haschildContext => childContext != null;
}
