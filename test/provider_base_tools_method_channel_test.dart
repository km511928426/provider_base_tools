import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider_base_tools/provider_base_tools_method_channel.dart';

void main() {
  MethodChannelProviderBaseTools platform = MethodChannelProviderBaseTools();
  const MethodChannel channel = MethodChannel('provider_base_tools');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
