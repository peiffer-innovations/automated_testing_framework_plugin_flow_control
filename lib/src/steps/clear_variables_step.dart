import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Test step that asserts that the value equals (or does not equal) a specific
/// value.
class ClearVariablesStep extends TestRunnerStep {
  /// Creates an instance from a JSON-like map structure.  This expects the
  /// following format:
  ///
  /// ```json
  /// {
  /// }
  /// ```
  static ClearVariablesStep fromDynamic(dynamic map) {
    ClearVariablesStep result;

    if (map != null) {
      result = ClearVariablesStep();
    }

    return result;
  }

  /// Executes the step.  This will
  @override
  Future<void> execute({
    @required TestReport report,
    @required TestController tester,
  }) async {
    var name = 'clear_variables()';
    log(
      name,
      tester: tester,
    );

    tester.clearVariables();
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
