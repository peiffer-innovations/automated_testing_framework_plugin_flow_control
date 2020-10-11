import 'dart:async';

import 'package:automated_testing_framework/automated_testing_framework.dart';

/// Function that can be assigned to a variable and executed by the
/// [ExecuteVariableFunctionStep].
typedef TestVariableFunction = Future<dynamic> Function(
  TestController tester,
  TestReport report,
);
