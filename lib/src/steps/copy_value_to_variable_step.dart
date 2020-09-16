import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:flutter/material.dart';
import 'package:json_class/json_class.dart';
import 'package:meta/meta.dart';

/// Test step that copies the value from the [Testable] to a variable identified
/// with the [variableName].
class CopyValueToVariableStep extends TestRunnerStep {
  CopyValueToVariableStep({
    @required this.testableId,
    @required this.variableName,
    this.timeout,
  })  : assert(testableId?.isNotEmpty == true),
        assert(variableName?.isNotEmpty == true);

  /// The id of the [Testable] widget to interact with.
  final String testableId;

  /// The maximum amount of time this step will wait while searching for the
  /// [Testable] on the widget tree.
  final Duration timeout;

  /// The variable name.
  final String variableName;

  /// Creates an instance from a JSON-like map structure.  This expects the
  /// following format:
  ///
  /// ```json
  /// {
  ///   "testableId": <String>,
  ///   "timeout": <number>,
  ///   "variableName": <String>
  /// }
  /// ```
  ///
  /// See also:
  /// * [JsonClass.parseBool]
  /// * [JsonClass.parseDurationFromSeconds]
  static CopyValueToVariableStep fromDynamic(dynamic map) {
    CopyValueToVariableStep result;

    if (map != null) {
      result = CopyValueToVariableStep(
        testableId: map['testableId'],
        timeout: JsonClass.parseDurationFromSeconds(map['timeout']),
        variableName: map['variableName'],
      );
    }

    return result;
  }

  /// Executes the step.  This will first look for the [Testable], get the value
  /// from the [Testable], then compare it against the set [value].
  @override
  Future<void> execute({
    @required TestReport report,
    @required TestController tester,
  }) async {
    String testableId = tester.resolveVariable(this.testableId);
    String variableName = tester.resolveVariable(this.variableName);
    assert(testableId?.isNotEmpty == true);

    var name = "copy_value_to_variable('$testableId', '$variableName')";
    log(
      name,
      tester: tester,
    );
    var finder = await waitFor(
      testableId,
      tester: tester,
      timeout: timeout,
    );

    await sleep(
      tester.delays.postFoundWidget,
      tester: tester,
    );

    var widgetFinder = finder.evaluate();
    var found = false;
    if (widgetFinder?.isNotEmpty == true) {
      StatefulElement element = widgetFinder.first;

      var state = element.state;
      if (state is TestableState) {
        try {
          var actual = state.onRequestValue();
          found = true;

          tester.setVariable(
            value: actual,
            variableName: variableName,
          );
        } catch (e) {
          found = false;
        }
      }
    }
    if (found != true) {
      throw Exception(
        'testableId: [$testableId] -- could not locate Testable with a functional [onRequestValue] method.',
      );
    }
  }

  /// Overidden to ignore the delay
  @override
  Future<void> postStepSleep(Duration duration) async {}

  /// Converts this to a JSON compatible map.  For a description of the format,
  /// see [fromDynamic].
  @override
  Map<String, dynamic> toJson() => {
        'testableId': testableId,
        'timeout': timeout?.inSeconds,
        'variableName': variableName,
      };
}
