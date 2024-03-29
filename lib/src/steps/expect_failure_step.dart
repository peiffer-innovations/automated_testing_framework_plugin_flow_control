import 'package:automated_testing_framework/automated_testing_framework.dart';

/// Test step that expects the sub-step to fail with an exception or else this
/// step will fail.  Useful for negative tests.
class ExpectFailureStep extends TestRunnerStep {
  ExpectFailureStep({
    this.step,
  });

  static const id = 'expect_failure';

  static List<String> get behaviorDrivenDescriptions => List.unmodifiable([
        'expect the substep #1 to fail.',
      ]);

  final dynamic step;

  @override
  String get stepId => id;

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
  static ExpectFailureStep? fromDynamic(dynamic map) {
    ExpectFailureStep? result;

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
    required CancelToken cancelToken,
    required TestReport report,
    required TestController tester,
  }) async {
    final step = tester.resolveVariable(this.step);

    final name = '$id()';
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
      final testStep = TestStep.fromDynamic(step);

      final runnerStep = tester.registry.getRunnerStep(
        id: testStep.id,
        values: testStep.values,
      )!;
      if (cancelToken.cancelled == true) {
        throw Exception('[CANCELLED]: the step has been cancelled.');
      }
      if (tester.delays.preStep.inMilliseconds > 0) {
        await runnerStep.preStepSleep(tester.delays.preStep);
      }

      if (cancelToken.cancelled == true) {
        throw Exception('[CANCELLED]: the step has been cancelled.');
      }
      report.startStep(
        testStep,
        subStep: true,
      );
      var failureEncountered = false;
      try {
        try {
          await runnerStep.execute(
            cancelToken: cancelToken,
            report: report,
            tester: tester,
          );
        } finally {
          report.endStep(testStep);
        }

        if (cancelToken.cancelled == true) {
          throw Exception('[CANCELLED]: the step has been cancelled.');
        }
        if (tester.delays.postStep.inMilliseconds > 0) {
          await runnerStep.postStepSleep(tester.delays.preStep);
        }
      } catch (e) {
        failureEncountered = true;
        log(
          'expect_failure: Expected exception encountered: $e',
          tester: tester,
        );
      }
      if (failureEncountered != true) {
        throw Exception('expect_failure: failing lack of exception');
      }
    }
  }

  @override
  String getBehaviorDrivenDescription(TestController tester) {
    var result = behaviorDrivenDescriptions[0];

    TestRunnerStep? runnerStep;
    try {
      runnerStep = tester.registry.getRunnerStep(
        id: step['id'],
        values: step['values'],
      );
    } catch (e) {
      // no-op
    }

    final desc = runnerStep == null
        ? 'nothing.'
        : runnerStep.getBehaviorDrivenDescription(tester);

    result += '\n1. Then I will execute the sub-step, $desc\n';

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
  Map<String, dynamic> toJson() => {
        'step': step,
      };
}
