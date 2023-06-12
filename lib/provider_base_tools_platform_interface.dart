import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'provider_base_tools_method_channel.dart';

abstract class ProviderBaseToolsPlatform extends PlatformInterface {
  /// Constructs a ProviderBaseToolsPlatform.
  ProviderBaseToolsPlatform() : super(token: _token);

  static final Object _token = Object();

  static ProviderBaseToolsPlatform _instance = MethodChannelProviderBaseTools();

  /// The default instance of [ProviderBaseToolsPlatform] to use.
  ///
  /// Defaults to [MethodChannelProviderBaseTools].
  static ProviderBaseToolsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ProviderBaseToolsPlatform] when
  /// they register themselves.
  static set instance(ProviderBaseToolsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
