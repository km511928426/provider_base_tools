import 'package:flutter/material.dart';

class ContextList {
  static final ContextList _instance = ContextList._internal();

  static ContextList get getInstance {
    return _instance;
  }

  ContextList._internal();

  List<BuildContext>? _contextList;
  List<BuildContext> get contextList => _contextList ?? [];

  set contextList(List<BuildContext>? value) => _contextList = value;

  addItem(BuildContext context) {
    if (contextList.isEmpty) {
      contextList = [];
    }
    if (contextList.any((element) => element == context) == false) {
      contextList.insert(contextList.length, context);
    } else {
      contextList
          .removeAt(contextList.indexWhere((element) => element == context));
      contextList.insert(contextList.length, context);
    }
  }

  removeItem() {
    if (contextList.isEmpty) {
      contextList = [];
    }
    contextList.removeLast();
  }

  clear() => contextList.clear();
}
