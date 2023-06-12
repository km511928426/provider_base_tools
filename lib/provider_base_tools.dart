/*
 * @Author: cheng
 * @Version: 1.0
 * @Date: 2023-05-26 15:03:04
 * @LastEditors: cheng
 * @LastEditTime: 2023-05-27 13:38:51
 * @FilePath: \provider_base_tools\lib\provider_base_tools.dart
 * @ObjectDescription: 
 */
// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'provider_base_tools_platform_interface.dart';
export 'tools.dart';

class ProviderBaseTools {
  Future<String?> getPlatformVersion() {
    return ProviderBaseToolsPlatform.instance.getPlatformVersion();
  }
}
