import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:automated_testing_framework_plugin_flow_control/automated_testing_framework_plugin_flow_control.dart';

/// Looks for a function registered as [variableName].  The function must have
/// a function signature of [TestVariableFunction].  The result of executing the
/// function will be placed in the [resultVariableName], or `_functionResult` if
/// omitted.
class ExecuteVariableFunctionStep extends TestRunnerStep {
  ExecuteVariableFunctionStep({
    this.resultVariableName,
    required this.variableName,
  }) : assert(variableName.isNotEmpty == true);

  static const id = 'execute_variable_function';

  static List<String> get behaviorDrivenDescriptions => List.unmodifiable([
        'execute the function defined in the `{{variableName}}` function.',
        'execute the function defined in the `{{variableName}}` function and place the result in the `{{resultVariableName}}` variable.',
      ]);

  final String? resultVariableName;
  final String variableName;

  @override
  String get stepId => id;

  /// Creates an instance from a JSON-like map structure.  This expects the
  /// following format:
  ///
  /// ```json
  /// {
  ///   "resultVariableName": <String>,
  ///   "variableName": <String>
  /// }
  /// ```
  ///
  /// See also:
  /// * [TestStep.fromDynamic]
  static ExecuteVariableFunctionStep? fromDynamic(dynamic map) {
    ExecuteVariableFunctionStep? result;

    if (map != null) {
      result = ExecuteVariableFunctionStep(
        resultVariableName: map['resultVariableName'],
        variableName: map['variableName']!,
      );
    }

    return result;
  }

  /// Executes the step.  This will looks for a function registered as
  /// [variableName].  The function must have a function signature of
  /// [TestVariableFunction].  The result of executing the function will be
  /// placed in the [resultVariableName], or `_functionResult` if omitted.
  @override
  Future<void> execute({
    required CancelToken cancelToken,
    required TestReport report,
    required TestController tester,
  }) async {
    final resultVariableName =
        tester.resolveVariable(this.resultVariableName) ?? '_functionResult';
    final name = "$id('$variableName', '$resultVariableName')";

    log(
      name,
      tester: tester,
    );
    final fun = tester.resolveVariable('{{$variableName}}');

    if (fun is TestVariableFunction) {
      if (cancelToken.cancelled == true) {
        throw Exception('[CANCELLED]: the step has been cancelled.');
      }
      final result = await fun(
        tester,
        report,
      );

      tester.setTestVariable(
        value: result,
        variableName: resultVariableName,
      );
    } else {
      throw Exception('$id: failing due to no function');
    }
  }

  @override
  String getBehaviorDrivenDescription(TestController tester) {
    var result = resultVariableName == null
        ? behaviorDrivenDescriptions[0]
        : behaviorDrivenDescriptions[1];

    result = result.replaceAll(
      '{{resultVariableName}}',
      resultVariableName ?? 'null',
    );
    result = result.replaceAll('{{variableName}}', variableName);

    return result;
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
        'resultVariableName': resultVariableName,
        'variableName': variableName,
      };
}
