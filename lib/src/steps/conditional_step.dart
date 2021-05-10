import 'package:automated_testing_framework/automated_testing_framework.dart';

/// Test step that will execute a sub-step based on whether the [variableName]
/// does or does not equal [whenTrue] or [whenFalse].
class ConditionalStep extends TestRunnerStep {
  ConditionalStep({
    this.value,
    required this.variableName,
    this.whenFalse,
    this.whenTrue,
  });

  static const id = 'conditional_step';

  static List<String> get behaviorDrivenDescriptions => List.unmodifiable([
        'compare `{{value}}` to the value inside of the `{{variableName}}` and execute #1 when they match and #2 when they do not.',
      ]);

  final String? value;
  final String variableName;
  final dynamic whenFalse;
  final dynamic whenTrue;

  @override
  String get stepId => id;

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
  static ConditionalStep? fromDynamic(dynamic map) {
    ConditionalStep? result;

    if (map != null) {
      result = ConditionalStep(
        value: map['value']?.toString(),
        variableName: map['variableName']!,
        whenFalse: map['whenFalse'],
        whenTrue: map['whenTrue'],
      );
    }

    return result;
  }

  /// Executes the step.  This will first get the variable with from the
  /// [TestController] using the [variableName].  This will compare the
  /// variable's value the [value] then execute the appropriate [whenTrue] or
  /// [whenFalse] step.
  @override
  Future<void> execute({
    required CancelToken cancelToken,
    required TestReport report,
    required TestController tester,
  }) async {
    String? value = tester.resolveVariable(this.value);
    String? variableName = tester.resolveVariable(this.variableName);
    var whenFalse = tester.resolveVariable(this.whenFalse);
    var whenTrue = tester.resolveVariable(this.whenTrue);
    assert(variableName?.isNotEmpty == true);

    var name = "$id('$variableName', '$value')";
    log(
      name,
      tester: tester,
    );

    var resolved = tester.resolveVariable('{{$variableName}}');
    var result =
        value == resolved || (value?.toString() == resolved?.toString());

    TestStep? step;
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
        cancelToken: cancelToken,
        report: report,
        step: step,
        subStep: true,
      );
    }
  }

  @override
  String getBehaviorDrivenDescription(TestController tester) {
    var result = behaviorDrivenDescriptions[0];

    result = result.replaceAll(
      '{{value}}',
      value ?? 'null',
    );
    result = result.replaceAll('{{variableName}}', variableName);

    TestRunnerStep? whenFalseStep;
    try {
      whenFalseStep = tester.registry.getRunnerStep(
        id: whenFalse['id'],
        values: whenFalse['values'],
      );
    } catch (e) {
      // no-op
    }

    TestRunnerStep? whenTrueStep;
    try {
      whenTrueStep = tester.registry.getRunnerStep(
        id: whenTrue['id'],
        values: whenTrue['values'],
      );
    } catch (e) {
      // no-op
    }

    var trueDesc = whenTrueStep == null
        ? 'nothing.'
        : whenTrueStep.getBehaviorDrivenDescription(tester);
    var falseDesc = whenFalseStep == null
        ? 'nothing.'
        : whenFalseStep.getBehaviorDrivenDescription(tester);
    result += '\n1. When they match, I will $trueDesc';
    result += '\n2. When they do not match, I will $falseDesc';

    result += '\n';

    return result;
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
