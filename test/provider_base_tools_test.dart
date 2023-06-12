import 'package:flutter_test/flutter_test.dart';
import 'package:provider_base_tools/provider_base_tools.dart';
import 'package:provider_base_tools/provider_base_tools_platform_interface.dart';
import 'package:provider_base_tools/provider_base_tools_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockProviderBaseToolsPlatform
    with MockPlatformInterfaceMixin
    implements ProviderBaseToolsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ProviderBaseToolsPlatform initialPlatform = ProviderBaseToolsPlatform.instance;

  test('$MethodChannelProviderBaseTools is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelProviderBaseTools>());
  });

  test('getPlatformVersion', () async {
    ProviderBaseTools providerBaseToolsPlugin = ProviderBaseTools();
    MockProviderBaseToolsPlatform fakePlatform = MockProviderBaseToolsPlatform();
    ProviderBaseToolsPlatform.instance = fakePlatform;

    expect(await providerBaseToolsPlugin.getPlatformVersion(), '42');
  });
}
