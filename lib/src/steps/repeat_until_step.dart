import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:flutter/material.dart';
import 'package:json_class/json_class.dart';
import 'package:meta/meta.dart';

/// Test step that iterates from [start] to [end] - 1 and executes [step] with
/// each iteration.  If set, tihs stores the current value in
/// [counterVariableName] and will use `_repeatNum` if [counterVariableName] is
/// not set.
class RepeatUntilStep extends TestRunnerStep {
  RepeatUntilStep({
    @required this.counterVariableName,
    @required this.maxIterations,
    @required this.step,
    @required this.value,
    @required this.variableName,
  })  : assert(step != null),
        assert(variableName != null);

  /// The counter variable name.
  final String counterVariableName;

  /// The maximum number of iterations.
  final dynamic maxIterations;

  /// The step to execute with each iteration.
  final dynamic step;

  /// The value to look for.
  final String value;

  /// The variable name.
  final String variableName;

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
  static RepeatUntilStep fromDynamic(dynamic map) {
    RepeatUntilStep result;

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

  ///
  @override
  Future<void> execute({
    @required TestReport report,
    @required TestController tester,
  }) async {
    var value = tester.resolveVariable(this.value)?.toString();
    var maxIterations =
        JsonClass.parseInt(tester.resolveVariable(this.maxIterations), 100);
    var step = tester.resolveVariable(this.step);
    String counterVariableName =
        tester.resolveVariable(this.counterVariableName) ?? '_repeatNum';
    String variableName = tester.resolveVariable(this.variableName);

    assert(variableName != null);

    var name =
        "repeat_until('$variableName', '$value', '$maxIterations', '$counterVariableName')";
    log(
      name,
      tester: tester,
    );

    var testStep = TestStep.fromDynamic(step);
    if (testStep == null) {
      throw Exception('repeat_until: failing due to no sub-step');
    }
    tester.setVariable(
      value: 0,
      variableName: counterVariableName,
    );

    var actual = tester.resolveVariable('{{$variableName}}')?.toString();
    var iterations = 0;
    while (actual != value) {
      tester.setVariable(
        value: iterations,
        variableName: counterVariableName,
      );
      log(
        'repeat_until: expected: [$value] -- actual: [$actual]',
        tester: tester,
      );
      if (maxIterations != null && iterations >= maxIterations) {
        throw Exception(
            'repeat_until: Max Iteration Count exceeded: $maxIterations');
      }

      await tester.executeStep(
        report: report,
        step: testStep,
        subStep: true,
      );

      actual = tester.resolveVariable('{{$counterVariableName}}')?.toString();

      iterations++;
    }
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
