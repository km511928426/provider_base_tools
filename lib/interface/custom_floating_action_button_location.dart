/*
 * @Author: cheng
 * @Version: 1.0
 * @Date: 2022-11-16 11:51:26
 * @LastEditors: cheng
 * @LastEditTime: 2022-11-16 11:51:28
 * @FilePath:  \provider_base_tools\lib\interface\CustomFloatingActionButtonLocation.dart
 * @ObjectDescription: FloatingActionButton自定义位置的简单实现
 */

import 'package:flutter/material.dart';

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX; // X方向的偏移量
  double offsetY; // Y方向的偏移量
  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
