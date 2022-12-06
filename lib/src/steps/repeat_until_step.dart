import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:json_class/json_class.dart';

/// Test step that iterates from [start] to [end] - 1 and executes [step] with
/// each iteration.  If set, tihs stores the current value in
/// [counterVariableName] and will use `_repeatNum` if [counterVariableName] is
/// not set.
class RepeatUntilStep extends TestRunnerStep {
  RepeatUntilStep({
    required this.counterVariableName,
    required this.maxIterations,
    required this.step,
    required this.value,
    required this.variableName,
  }) : assert(step != null);

  static const id = 'repeat_until';

  static List<String> get behaviorDrivenDescriptions => List.unmodifiable([
        'repeat the substeps until the `{{variableName}}` variable equals `{{value}}` using `{{counterVariableName}}` as the increment variable and automatically fails after `{{maxIterations}}`.',
        'repeat the substeps until the `{{variableName}}` variable equals `{{value}}` and automatically fails after `{{maxIterations}}`.',
        'repeat the substeps until the `{{variableName}}` variable equals `{{value}}` using `{{counterVariableName}}` as the increment variable.',
        'repeat the substeps until the `{{variableName}}` variable equals `{{value}}`.',
      ]);

  /// The counter variable name.
  final String? counterVariableName;

  /// The maximum number of iterations.
  final dynamic maxIterations;

  /// The step to execute with each iteration.
  final dynamic step;

  /// The value to look for.
  final String? value;

  /// The variable name.
  final String variableName;

  @override
  String get stepId => id;

  /// Creates an instance from a JSON-like map structure.  This expects the
  /// following format:
  ///
  /// ```json
  /// {
  ///   "counterVariableName": <String>,
  ///   "maxIterations": <number>,
  ///   "step": <TestStep>,
  ///   "value": <String>,
  ///   "variableName": <String>
  /// }
  /// ```
  ///
  /// See also:
  /// * [TestStep.fromDynamic]
  static RepeatUntilStep? fromDynamic(dynamic map) {
    RepeatUntilStep? result;

    if (map != null) {
      result = RepeatUntilStep(
        counterVariableName: map['counterVariableName'],
        maxIterations: map['maxIterations'],
        step: map['step'],
        value: map['value']?.toString(),
        variableName: map['variableName'],
      );
    }

    return result;
  }

  @override
  Future<void> execute({
    required CancelToken cancelToken,
    required TestReport report,
    required TestController tester,
  }) async {
    final value = tester.resolveVariable(this.value)?.toString();
    final maxIterations =
        JsonClass.parseInt(tester.resolveVariable(this.maxIterations), 100);
    final step = tester.resolveVariable(this.step);
    final counterVariableName =
        tester.resolveVariable(this.counterVariableName) ?? '_repeatNum';
    final variableName = tester.resolveVariable(this.variableName);

    final name =
        "$id('$variableName', '$value', '$maxIterations', '$counterVariableName')";
    log(
      name,
      tester: tester,
    );

    if (step == null) {
      throw Exception('repeat_until: failing due to no sub-step');
    }
    final testStep = TestStep.fromDynamic(step);
    tester.setTestVariable(
      value: 0,
      variableName: counterVariableName,
    );

    var actual = tester.resolveVariable('{{$variableName}}')?.toString();
    var iterations = 0;
    while (actual != value) {
      if (cancelToken.cancelled == true) {
        throw Exception('[CANCELLED]: the step has been cancelled.');
      }

      tester.setTestVariable(
        value: iterations,
        variableName: counterVariableName,
      );
      log(
        '$id: expected: [$value] -- actual: [$actual]',
        tester: tester,
      );
      if (maxIterations != null && iterations >= maxIterations) {
        throw Exception('$id: Max Iteration Count exceeded: $maxIterations');
      }

      await tester.executeStep(
        cancelToken: cancelToken,
        report: report,
        step: testStep,
        subStep: true,
      );

      actual = tester.resolveVariable('{{$counterVariableName}}')?.toString();

      iterations++;
    }
  }

  @override
  String getBehaviorDrivenDescription(TestController tester) {
    var result = behaviorDrivenDescriptions[0];

    if (counterVariableName == null && maxIterations != null) {
      result = behaviorDrivenDescriptions[1];
    } else if (counterVariableName != null && maxIterations == null) {
      result = behaviorDrivenDescriptions[2];
    } else if (counterVariableName == null && maxIterations == null) {
      result = behaviorDrivenDescriptions[2];
    }

    TestRunnerStep? runnerStep;
    try {
      runnerStep = tester.registry.getRunnerStep(
        id: step['id'],
        values: step['values'],
      );
    } catch (e) {
      // no-op
    }

    result = result.replaceAll(
      '{{counterVariableName}}',
      counterVariableName ?? 'null',
    );
    result = result.replaceAll('{{maxIterations}}', maxIterations ?? 'null');
    result = result.replaceAll('{{value}}', value ?? 'null');
    result = result.replaceAll('{{variableName}}', variableName);

    final desc = runnerStep == null
        ? 'nothing.'
        : runnerStep.getBehaviorDrivenDescription(tester);

    result += '\n1. Then I will execute the sub-step, $desc\n';

    return result;
  }

  /// Overidden to ignore the delay
  @override
  Future<void> postStepSleep(Duration duration) async {}

  /// Overidden to ignore the delay
  @override
  Future<void> preStepSleep(Duration duration) async {}

  /// Converts this to a JSON compatible map.  For a description of the format,
  /// see [fromDynamic].
  @override
  Map<String, dynamic> toJson() => {
        'counterVariableName': counterVariableName,
        'maxIterations': maxIterations,
        'step': step,
        'value': value,
        'variableName': variableName,
      };
}
