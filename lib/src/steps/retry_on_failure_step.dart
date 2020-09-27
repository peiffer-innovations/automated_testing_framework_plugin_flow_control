import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:flutter/material.dart';
import 'package:json_class/json_class.dart';
import 'package:meta/meta.dart';

/// Test step that will retry up to [retryCount] times when a sub-step fails.
class RetryOnFailureStep extends TestRunnerStep {
  RetryOnFailureStep({
    @required this.retryCount,
    @required this.step,
  }) : assert(step != null);

  final String retryCount;
  final dynamic step;

  /// Creates an instance from a JSON-like map structure.  This expects the
  /// following format:
  ///
  /// ```json
  /// {
  ///   "retryCount": <int>
  ///   "step": <TestStep>,
  /// }
  /// ```
  ///
  /// See also:
  /// * [TestStep.fromDynamic]
  static RetryOnFailureStep fromDynamic(dynamic map) {
    RetryOnFailureStep result;

    if (map != null) {
      result = RetryOnFailureStep(
        retryCount: map['retryCount'],
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
    var retryCount =
        JsonClass.parseInt(tester.resolveVariable(this.retryCount), 1);
    var step = tester.resolveVariable(this.step);

    var name = "retry_on_failure('$retryCount')";
    log(
      name,
      tester: tester,
    );

    if (step == null) {
      throw Exception('retry_on_failure: failing due to no sub-step');
    } else {
      for (var i = 0; i < retryCount; i++) {
        tester.setVariable(
          value: i,
          variableName: '_retryNum',
        );

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

        report?.startStep(
          testStep,
          subStep: true,
        );
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

          break;
        } catch (e) {
          log(
            'retry_on_failure: retry ${i + 1} / $retryCount.',
            tester: tester,
          );
          if (i == retryCount - 1) {
            rethrow;
          }
        }
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
