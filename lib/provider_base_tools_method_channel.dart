import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'provider_base_tools_platform_interface.dart';

/// An implementation of [ProviderBaseToolsPlatform] that uses method channels.
class MethodChannelProviderBaseTools extends ProviderBaseToolsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('provider_base_tools');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
