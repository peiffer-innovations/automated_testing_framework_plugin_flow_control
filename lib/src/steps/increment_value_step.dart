import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:flutter/material.dart';
import 'package:json_class/json_class.dart';
import 'package:meta/meta.dart';

/// Test step that increments the value stored in [variableName].
class IncrementValueStep extends TestRunnerStep {
  IncrementValueStep({
    @required this.increment,
    @required this.variableName,
  }) : assert(variableName?.isNotEmpty == true);

  /// The value to increment the [variableName] by.
  final String increment;

  /// The variable name.
  final String variableName;

  /// Creates an instance from a JSON-like map structure.  This expects the
  /// following format:
  ///
  /// ```json
  /// {
  ///   "increment": <number>,
  ///   "variableName": <String>
  /// }
  /// ```
  static IncrementValueStep fromDynamic(dynamic map) {
    IncrementValueStep result;

    if (map != null) {
      result = IncrementValueStep(
        increment: map['increment'],
        variableName: map['variableName'],
      );
    }

    return result;
  }

  /// Executes the step.  This will look for the variable named [variableName],
  /// get the value as an int.  If the [increment] cannot be parsed as an [int]
  /// then this will default to using 1.
  @override
  Future<void> execute({
    @required TestReport report,
    @required TestController tester,
  }) async {
    var increment =
        JsonClass.parseInt(tester.resolveVariable(this.increment), 1);
    String variableName = tester.resolveVariable(this.variableName);

    var name = "increment_value('$increment', '$variableName')";
    log(
      name,
      tester: tester,
    );

    var value = JsonClass.parseInt(
      tester.resolveVariable('{{$variableName}}'),
    );

    if (value == null) {
      value = 0;
    } else {
      value += increment;
    }

    tester.setVariable(
      value: value,
      variableName: variableName,
    );
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
        'increment': increment,
        'variableName': variableName,
      };
}
