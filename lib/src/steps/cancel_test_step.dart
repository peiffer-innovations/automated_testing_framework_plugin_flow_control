import 'dart:async';

import 'package:automated_testing_framework/automated_testing_framework.dart';

/// Test step that will cancel the test and prevent future steps from executing.
class CancelTestStep extends TestRunnerStep {
  static const id = 'cancel_test';

  @override
  String get stepId => id;

  static List<String> get behaviorDrivenDescriptions => List.unmodifiable([
        'cancel the test run.',
      ]);

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
  static CancelTestStep? fromDynamic(dynamic map) {
    CancelTestStep? result;

    if (map != null) {
      result = CancelTestStep();
    }

    return result;
  }

  /// Executes the step.  This will instruct the [tester] to cancel the test.
  @override
  Future<void> execute({
    required CancelToken cancelToken,
    required TestReport report,
    required TestController tester,
  }) {
    final name = '$id()';
    log(
      name,
      tester: tester,
    );

    tester.cancelRunningTests();

    return Future.value(null);
  }

  @override
  String getBehaviorDrivenDescription(TestController tester) {
    final result = behaviorDrivenDescriptions[0];

    return result;
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
