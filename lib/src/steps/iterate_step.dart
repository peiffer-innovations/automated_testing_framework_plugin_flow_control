import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:json_class/json_class.dart';

/// Test step that iterates from [start] to [end] - 1 and executes [step] with
/// each iteration.  If set, tihs stores the current value in [variableName] and
/// will use `_iterateNum` if [variableName] is not set.
class IterateStep extends TestRunnerStep {
  IterateStep({
    required this.end,
    required this.start,
    required this.step,
    required this.variableName,
  })  : assert(end != null),
        assert(step != null);

  static const id = 'iterate';

  static List<String> get behaviorDrivenDescriptions => List.unmodifiable([
        'iterate from `{{start}}` to `{{end}}` using the variable named `{{variableName}}` while executing the substep #1.',
      ]);

  /// The ending value.
  final dynamic end;

  /// The starting value.
  final dynamic start;

  /// The step to execute with each iteration.
  final dynamic step;

  /// The variable name.
  final String? variableName;

  @override
  String get stepId => id;

  /// Creates an instance from a JSON-like map structure.  This expects the
  /// following format:
  ///
  /// ```json
  /// {
  ///   "end": <number>,
  ///   "start": <String>,
  ///   "step": <TestStep>,
  ///   "variableName": <String>,
  /// }
  /// ```
  ///
  /// See also:
  /// * [TestStep.fromDynamic]
  static IterateStep? fromDynamic(dynamic map) {
    IterateStep? result;

    if (map != null) {
      result = IterateStep(
        end: map['end'],
        start: map['start'],
        step: map['step'],
        variableName: map['variableName'],
      );
    }

    return result;
  }

  /// Executes the step.  This will iterate from [start] to [end] - 1 and place
  /// the current value inside of [variableName] (or `_iterateNum` if not set).
  /// The [step] will be executed with each iteration.
  @override
  Future<void> execute({
    required CancelToken cancelToken,
    required TestReport report,
    required TestController tester,
  }) async {
    var end = JsonClass.parseInt(tester.resolveVariable(this.end))!;
    var start = JsonClass.parseInt(tester.resolveVariable(this.start), 0)!;
    var step = tester.resolveVariable(this.step);
    String variableName =
        tester.resolveVariable(this.variableName) ?? '_iterateNum';

    assert(end > start);

    var name = "$id('$start', '$end', '$variableName')";
    log(
      name,
      tester: tester,
    );

    if (step == null) {
      throw Exception('iterate: failing due to no sub-step');
    }
    var testStep = TestStep.fromDynamic(step);

    for (var i = start; i < end; i++) {
      if (cancelToken.cancelled == true) {
        throw Exception('[CANCELLED]: the step has been cancelled.');
      }
      var name = "iterate('$start', '$end', '$variableName', '$i')";
      log(
        name,
        tester: tester,
      );
      tester.setVariable(
        value: i,
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

  @override
  String getBehaviorDrivenDescription(TestController tester) {
    var result = behaviorDrivenDescriptions[0];

    result = result.replaceAll('{{start}}', start);
    result = result.replaceAll('{{end}}', end);

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
        'end': end,
        'start': start,
        'step': step,
        'variableName': variableName,
      };
}
