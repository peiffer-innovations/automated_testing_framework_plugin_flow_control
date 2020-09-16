import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:flutter/material.dart';
import 'package:json_class/json_class.dart';
import 'package:meta/meta.dart';

/// Test step that asserts that the value within [variableName] equals (or does
/// not equal) a specific [value].
class AssertVariableValueStep extends TestRunnerStep {
  AssertVariableValueStep({
    @required this.equals,
    @required this.value,
    @required this.variableName,
  })  : assert(equals != null),
        assert(variableName?.isNotEmpty == true);

  /// Set to [true] if the value from the [variableName] must equal the set
  /// [value].  Set to [false] if the value from the [variableName] must not
  /// equal the [value].
  final bool equals;

  /// The name of the variable to test.
  final String variableName;

  /// The [value] to test againt when comparing the [Testable]'s value.
  final String value;

  /// Creates an instance from a JSON-like map structure.  This expects the
  /// following format:
  ///
  /// ```json
  /// {
  ///   "equals": <bool>,
  ///   "value": <String>,
  ///   "variableName": <String>
  /// }
  /// ```
  ///
  /// See also:
  /// * [JsonClass.parseBool]
  static AssertVariableValueStep fromDynamic(dynamic map) {
    AssertVariableValueStep result;

    if (map != null) {
      result = AssertVariableValueStep(
        equals:
            map['equals'] == null ? true : JsonClass.parseBool(map['equals']),
        value: map['value']?.toString(),
        variableName: map['variableName'],
      );
    }

    return result;
  }

  /// Executes the step.  This will
  @override
  Future<void> execute({
    @required TestReport report,
    @required TestController tester,
  }) async {
    String value = tester.resolveVariable(this.value);
    String variableName = tester.resolveVariable(this.variableName);
    assert(variableName?.isNotEmpty == true);

    var name = "assert_variable_value('$variableName', '$value', '$equals')";
    log(
      name,
      tester: tester,
    );

    var match = false;
    var actual = tester.resolveVariable(variableName);
    if (equals == (actual?.toString() == value)) {
      match = true;
    }
    if (match != true) {
      throw Exception(
        'variableName: [$variableName] -- actualValue: [$actual] ${equals == true ? '!=' : '=='} [$value].',
      );
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
        'equals': equals,
        'variableName': variableName,
        'value': value,
      };
}
