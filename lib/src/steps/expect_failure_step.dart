import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Test step that expects the sub-step to fail with an exception or else this
/// step will fail.  Useful for negative tests.
class ExpectFailureStep extends TestRunnerStep {
  ExpectFailureStep({
    this.step,
  });

  final dynamic step;

  /// Creates an instance from a JSON-like map structure.  This expects the
  /// following format:
  ///
  /// ```json
  /// {
  ///   "step": <TestStep>
  /// }
  /// ```
  ///
  /// See also:
  /// * [TestStep.fromDynamic]
  static ExpectFailureStep fromDynamic(dynamic map) {
    ExpectFailureStep result;

    if (map != null) {
      result = ExpectFailureStep(
        step: map['step'],
      );
    }

    return result;
  }

  /// Executes the step.  This will succeed if, and only if, there exists a
  /// sub-step and when executed, the sub-step throws an exception.
  @override
  Future<void> execute({
    @required TestReport report,
    @required TestController tester,
  }) async {
    var step = tester.resolveVariable(this.step);

    var name = 'expect_failure()';
    log(
      name,
      tester: tester,
    );

    if (step == null) {
      throw Exception('expect_failure: failing due to no sub-step');
    } else {
      // This purposefully does not use [TestController.executeStep] because
      // that provides no way to keep the sub-step from triggering an error.
      // So instead, the logic from the controller is copied to ensure the
      // report has the step but failures are treated as successes.
      var testStep = TestStep.fromDynamic(step);

      var runnerStep = tester.registry.getRunnerStep(
        id: testStep.id,
        values: testStep.values,
      );
      if (tester.delays.preStep.inMilliseconds > 0) {
        await runnerStep.preStepSleep(tester.delays.preStep);
      }

      report?.startStep(testStep);
      try {
        try {
          await runnerStep.execute(
            report: report,
            tester: tester,
          );
        } finally {
          report?.endStep(testStep);
        }

        if (tester.delays.postStep.inMilliseconds > 0) {
          await runnerStep.postStepSleep(tester.delays.preStep);
        }

        throw Exception('expect_failure: failing lack of exception');
      } catch (e) {
        log(
          'expect_failure: Expected exception encountered: $e',
          tester: tester,
        );
      }
    }
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
  Map<String, dynamic> toJson() => {
        'step': step,
      };
}
