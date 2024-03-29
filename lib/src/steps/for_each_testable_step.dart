import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:flutter/material.dart';

/// Iterates through all active [Testable] widgets that have an id that matches
/// the given [regEx], sets the id in [variableName] (or `_testableId` if no
/// [variableName] is set) and calls the [step].
class ForEachTestableStep extends TestRunnerStep {
  ForEachTestableStep({
    required this.step,
    required this.regEx,
    required this.variableName,
  });

  static const id = 'for_each_testable';

  static List<String> get behaviorDrivenDescriptions => List.unmodifiable([
        'execute the #1 for each testable matching the regex "`{{regEx}}`".',
        "execute the #1 for each testable matching the regex \"`{{regEx}}`\" and place the testable's id in the `{{variableName}}` variable.",
      ]);

  /// The step to execute with each iteration.
  final dynamic step;

  /// The value to look for.
  final String regEx;

  /// The variable name.
  final String? variableName;

  @override
  String get stepId => id;

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
  static ForEachTestableStep? fromDynamic(dynamic map) {
    ForEachTestableStep? result;

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
    required CancelToken cancelToken,
    required TestReport report,
    required TestController tester,
  }) async {
    final regEx = tester.resolveVariable(this.regEx).toString();
    final variableName =
        tester.resolveVariable(this.variableName) ?? '_testableId';

    final name = "$id('$regEx', '$variableName')";
    log(
      name,
      tester: tester,
    );

    TestStep? testStep;
    if (step != null) {
      testStep = TestStep.fromDynamic(step);
    }
    if (testStep == null) {
      throw Exception('for_each_testable: failing due to no sub-step');
    }

    final regExp = RegExp(regEx);
    final testables = find.byType(Testable).evaluate();
    for (var testable in testables) {
      if (cancelToken.cancelled == true) {
        throw Exception('[CANCELLED]: the step has been cancelled.');
      }
      final key = testable.widget.key;
      if (key is ValueKey) {
        final id = key.value.toString();
        if (id.isNotEmpty == true && regExp.hasMatch(id)) {
          log(
            'for_each_testable: testableId: [$id]',
            tester: tester,
          );
          tester.setTestVariable(
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

  @override
  String getBehaviorDrivenDescription(TestController tester) {
    var result = variableName == null
        ? behaviorDrivenDescriptions[0]
        : behaviorDrivenDescriptions[1];

    result = result.replaceAll('{{regEx}}', regEx);
    result = result.replaceAll('{{variableName}}', variableName ?? 'null');

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
