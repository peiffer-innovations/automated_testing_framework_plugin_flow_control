import 'dart:convert';

import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:automated_testing_framework_example/automated_testing_framework_example.dart';
import 'package:automated_testing_framework_plugin_flow_control/automated_testing_framework_plugin_flow_control.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:websafe_platform/websafe_platform.dart';

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.time}: ${record.message}');
    if (record.error != null) {
      // ignore: avoid_print
      print('${record.error}');
    }
    if (record.stackTrace != null) {
      // ignore: avoid_print
      print('${record.stackTrace}');
    }
  });

  WidgetsFlutterBinding.ensureInitialized();

  TestFlowControlHelper.registerTestSteps();

  var gestures = TestableGestures();
  var wsPlatform = WebsafePlatform();
  if (wsPlatform.isFuchsia() ||
      wsPlatform.isLinux() ||
      wsPlatform.isMacOS() ||
      wsPlatform.isWindows() ||
      wsPlatform.isWeb()) {
    gestures = TestableGestures(
      widgetLongPress: null,
      widgetSecondaryLongPress: TestableGestureAction.open_test_actions_page,
      widgetSecondaryTap: TestableGestureAction.open_test_actions_dialog,
    );
  }

  List<String> allTests = List<String>.from(
    json.decode(
      await rootBundle.loadString(
        'assets/all_tests.json',
      ),
    ),
  );

  allTests.addAll(
    List<String>.from(
      json.decode(
        await rootBundle.loadString(
          'packages/automated_testing_framework_example/assets/all_tests.json',
        ),
      ),
    ),
  );

  runApp(App(
    options: TestExampleOptions(
      autorun: kProfileMode,
      enabled: true,
      gestures: gestures,
      testReader: AssetTestStore(testAssets: allTests).testReader,
      testWidgetsEnabled: true,
      testWriter: ClipboardTestStore.testWriter,
    ),
  ));
}
