import 'dart:async';

import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Test step that will cancel the test and prevent future steps from executing.
class CancelTestStep extends TestRunnerStep {
  /// Creates an instance from a JSON-like map structure.  This expects the
  /// following format:
  ///
  /// ```json
  /// {
  /// }
  /// ```
  ///
  /// See also:
  /// * [TestStep.fromDynamic]
  static CancelTestStep fromDynamic(dynamic map) {
    CancelTestStep result;

    if (map != null) {
      result = CancelTestStep();
    }

    return result;
  }

  /// Executes the step.  This will instruct the [tester] to cancel the test.
  @override
  Future<void> execute({
    @required CancelToken cancelToken,
    @required TestReport report,
    @required TestController tester,
  }) {
    var name = 'cancel_test()';
    log(
      name,
      tester: tester,
    );

    tester.cancelRunningTests();

    return Future.value(null);
  }

  /// Overidden to ignore the delay
  @override
  Future<void> preStepSleep(Duration duration) async {}

  /// Overidden to ignore the delay
  @override
  Future<void> postStepSleep(Duration duration) async {}

  /// Converts this to a JSON compatible map.  For a description of the format,
  /// see [fromDynamic].
  @override
  Map<String, dynamic> toJson() => {};
}
