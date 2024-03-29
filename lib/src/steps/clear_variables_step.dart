import 'package:automated_testing_framework/automated_testing_framework.dart';

/// Test step that asserts that the value equals (or does not equal) a specific
/// value.
class ClearVariablesStep extends TestRunnerStep {
  static const id = 'clear_variables';

  static List<String> get behaviorDrivenDescriptions => List.unmodifiable([
        'clear all custom variables from the registry.',
      ]);

  @override
  String get stepId => id;

  /// Creates an instance from a JSON-like map structure.  This expects the
  /// following format:
  ///
  /// ```json
  /// {
  /// }
  /// ```
  static ClearVariablesStep? fromDynamic(dynamic map) {
    ClearVariablesStep? result;

    if (map != null) {
      result = ClearVariablesStep();
    }

    return result;
  }

  /// Executes the step.  This will
  @override
  Future<void> execute({
    required CancelToken cancelToken,
    required TestReport report,
    required TestController tester,
  }) async {
    final name = '$id()';
    log(
      name,
      tester: tester,
    );

    tester.clearTestVariables();
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
