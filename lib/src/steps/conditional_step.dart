import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Test step that asserts that the value equals (or does not equal) a specific
/// value.
class ConditionalStep extends TestRunnerStep {
  ConditionalStep({
    this.value,
    @required this.variableName,
    this.whenFalse,
    this.whenTrue,
  });

  final String value;
  final String variableName;
  final dynamic whenFalse;
  final dynamic whenTrue;

  /// Creates an instance from a JSON-like map structure.  This expects the
  /// following format:
  ///
  /// ```json
  /// {
  ///   "value": <String>,
  ///   "variableName": <String>,
  ///   "whenFalse": <TestStep>,
  ///   "whenTrue": <TestStep>
  /// }
  /// ```
  ///
  /// See also:
  /// * [TestStep.fromDynamic]
  static ConditionalStep fromDynamic(dynamic map) {
    ConditionalStep result;

    if (map != null) {
      result = ConditionalStep(
        value: map['value']?.toString(),
        variableName: map['variableName'],
        whenFalse: map['whenFalse'],
        whenTrue: map['whenTrue'],
      );
    }

    return result;
  }

  /// Executes the step.  This will first get the variable with from the
  /// [TestController] using the [key].  This will compare the variable's value
  /// to either the [conditional] or the [value] then execute the appropriate
  /// [whenTrue] or [whenFalse] step.
  @override
  Future<void> execute({
    @required TestReport report,
    @required TestController tester,
  }) async {
    String value = tester.resolveVariable(this.value);
    String variableName = tester.resolveVariable(this.variableName);
    var whenFalse = tester.resolveVariable(this.whenFalse);
    var whenTrue = tester.resolveVariable(this.whenTrue);
    assert(variableName?.isNotEmpty == true);

    var name = "conditional('$variableName', '$value')";
    log(
      name,
      tester: tester,
    );

    var result = value == tester.resolveVariable('{{$variableName}}');

    TestStep step;
    var resultStep = result == true ? whenTrue : whenFalse;
    if (resultStep != null) {
      step = TestStep.fromDynamic(resultStep);
    }

    if (step == null) {
      log(
        'conditional: result: [$result] -- no step',
        tester: tester,
      );
    } else {
      log(
        'conditional: result: [$result] -- executing step',
        tester: tester,
      );
      await tester.executeStep(
        report: report,
        step: step,
        subStep: true,
      );
    }
  }

  /// Converts this to a JSON compatible map.  For a description of the format,
  /// see [fromDynamic].
  @override
  Map<String, dynamic> toJson() => {
        'value': value,
        'variableName': variableName,
        'whenTrue': whenTrue,
        'whenFalse': whenFalse,
      };
}
