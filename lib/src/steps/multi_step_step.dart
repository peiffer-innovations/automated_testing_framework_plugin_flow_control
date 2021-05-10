import 'package:automated_testing_framework/automated_testing_framework.dart';

/// Test step that groups different [TestStep] to be executed
/// as a block.
class MultiStepStep extends TestRunnerStep {
  MultiStepStep({
    this.debugLabel,
    required this.steps,
  });

  static const id = 'multi_step';

  static List<String> get behaviorDrivenDescriptions => List.unmodifiable([
        'execute the multiple substeps.',
      ]);

  final String? debugLabel;
  final List<dynamic> steps;

  @override
  String get stepId => id;

  /// Creates an instance from a JSON-like map structure.  This expects the
  /// following format:
  ///
  /// ```json
  /// {
  ///   "debugLabel": <String>,
  ///   "steps": <List<TestStep>>
  /// }
  /// ```
  ///
  /// See also:
  /// * [TestStep.fromDynamic]
  static MultiStepStep? fromDynamic(dynamic map) {
    MultiStepStep? result;

    if (map != null) {
      var debugLabel = map['debugLabel'] ?? 'Default MultiStep';
      List stepsList = map['steps'] is List ? map['steps'] : [map['steps']];

      result = MultiStepStep(
        debugLabel: debugLabel,
        steps: stepsList
          ..removeWhere(
            (step) => step == null,
          ),
      );
    }

    return result;
  }

  /// Executes the step. This will iterate through the List of steps
  /// and will await the execution of each one.
  @override
  Future<void> execute({
    required CancelToken cancelToken,
    required TestReport report,
    required TestController tester,
  }) async {
    log(
      "$id('$debugLabel')",
      tester: tester,
    );

    var stepNum = 0;
    for (var rawStep in steps) {
      if (cancelToken.cancelled == true) {
        throw Exception('[CANCELLED]: the step has been cancelled.');
      }

      var stepMap = tester.resolveVariable(rawStep);

      if (stepMap == null) {
        log(
          "multi_step('$debugLabel') step: [${stepMap['id']}] [${100 * stepNum ~/ steps.length}%] -- no step",
          tester: tester,
        );
      } else {
        var step = TestStep.fromDynamic(stepMap);
        log(
          "multi_step('$debugLabel') step: [${stepMap['id']}] [${100 * stepNum ~/ steps.length}%] -- executing step",
          tester: tester,
        );
        await tester.executeStep(
          cancelToken: cancelToken,
          report: report,
          step: step,
          subStep: true,
        );
      }
      stepNum++;
    }
    log(
      "multi_step('$debugLabel') -- finished execution",
      tester: tester,
    );
  }

  @override
  String getBehaviorDrivenDescription(TestController tester) {
    var result = behaviorDrivenDescriptions[0];

    var count = 1;
    for (var step in steps) {
      TestRunnerStep? runnerStep;
      try {
        runnerStep = tester.registry.getRunnerStep(
          id: step['id'],
          values: step['values'],
        );
      } catch (e) {
        // no-op
      }

      var desc = runnerStep == null
          ? 'nothing.'
          : runnerStep.getBehaviorDrivenDescription(tester);

      result += '\n$count. Then I will execute the sub-step, $desc\n';
      count++;
    }
    return result;
  }

  /// Converts this to a JSON compatible map.  For a description of the format,
  /// see [fromDynamic].
  @override
  Map<String, dynamic> toJson() {
    return {
      'debugLabel': debugLabel,
      'steps': steps,
    };
  }
}
