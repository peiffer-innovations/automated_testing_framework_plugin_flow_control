import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Iterates through all active [Testable] widgets that have an id that matches
/// the given [regEx], sets the id in [variableName] (or `_testableId` if no
/// [variableName] is set) and calls the [step].
class ForEachTestableStep extends TestRunnerStep {
  ForEachTestableStep({
    @required this.step,
    @required this.regEx,
    @required this.variableName,
  }) : assert(regEx != null);

  /// The step to execute with each iteration.
  final dynamic step;

  /// The value to look for.
  final String regEx;

  /// The variable name.
  final String variableName;

  /// Creates an instance from a JSON-like map structure.  This expects the
  /// following format:
  ///
  /// ```json
  /// {
  ///   "regEx": <String>,
  ///   "step": <TestStep>,
  ///   "variableName": <String>
  /// }
  /// ```
  ///
  /// See also:
  /// * [TestStep.fromDynamic]
  static ForEachTestableStep fromDynamic(dynamic map) {
    ForEachTestableStep result;

    if (map != null) {
      result = ForEachTestableStep(
        regEx: map['regEx'] ?? '.*',
        step: map['step'],
        variableName: map['variableName'],
      );
    }

    return result;
  }

  /// Iterates through all active [Testable] widgets that have an id that
  /// matches the given [regEx], sets the id in [variableName] (or `_testableId`
  /// if no [variableName] is set) and calls the [step].
  @override
  Future<void> execute({
    @required CancelToken cancelToken,
    @required TestReport report,
    @required TestController tester,
  }) async {
    var regEx = tester.resolveVariable(this.regEx)?.toString();
    String variableName =
        tester.resolveVariable(this.variableName) ?? '_testableId';

    assert(variableName != null);

    var name = "for_each_testable('$regEx', '$variableName')";
    log(
      name,
      tester: tester,
    );

    var testStep = TestStep.fromDynamic(step);
    if (testStep == null) {
      throw Exception('for_each_testable: failing due to no sub-step');
    }

    var regExp = RegExp(regEx);
    var testables = find.byType(Testable).evaluate();
    for (var testable in testables) {
      if (cancelToken.cancelled == true) {
        throw Exception('[CANCELLED]: the step has been cancelled.');
      }
      var key = testable?.widget?.key;
      if (key is ValueKey) {
        var id = key.value?.toString();
        if (id?.isNotEmpty == true && regExp.hasMatch(id)) {
          log(
            'for_each_testable: testableId: [$id]',
            tester: tester,
          );
          tester.setVariable(
            value: id,
            variableName: variableName,
          );
          await tester.executeStep(
            cancelToken: cancelToken,
            report: report,
            step: testStep,
            subStep: true,
          );
        }
      }
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
        'regEx': regEx,
        'step': step,
        'variableName': variableName,
      };
}
