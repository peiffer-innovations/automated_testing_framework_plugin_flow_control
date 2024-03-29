import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:json_class/json_class.dart';

/// Test step that asserts that the value within [variableName] equals (or does
/// not equal) a specific [value].
class AssertVariableValueStep extends TestRunnerStep {
  AssertVariableValueStep({
    required this.caseSensitive,
    required this.equals,
    required this.value,
    required this.variableName,
  }) : assert(variableName.isNotEmpty == true);

  static const id = 'assert_variable_value';

  static List<String> get behaviorDrivenDescriptions => List.unmodifiable([
        'assert that the value in the variable `{{variableName}}` is `{{equals}}` to `{{value}}` using a case `{{caseSensitive}}` comparator.',
      ]);

  /// Set to [true] if the comparison should be case sensitive.  Set to [false]
  /// to allow the comparison to be case insensitive.
  final bool caseSensitive;

  /// Set to [true] if the value from the [variableName] must equal the set
  /// [value].  Set to [false] if the value from the [variableName] must not
  /// equal the [value].
  final bool equals;

  /// The name of the variable to test.
  final String variableName;

  /// The [value] to test againt when comparing the [Testable]'s value.
  final String? value;

  @override
  String get stepId => id;

  /// Creates an instance from a JSON-like map structure.  This expects the
  /// following format:
  ///
  /// ```json
  /// {
  ///   "caseSensitive": <bool>,
  ///   "equals": <bool>,
  ///   "value": <String>,
  ///   "variableName": <String>
  /// }
  /// ```
  ///
  /// See also:
  /// * [JsonClass.parseBool]
  static AssertVariableValueStep? fromDynamic(dynamic map) {
    AssertVariableValueStep? result;

    if (map != null) {
      result = AssertVariableValueStep(
        caseSensitive: map['caseSensitive'] == null
            ? true
            : JsonClass.parseBool(map['caseSensitive']),
        equals:
            map['equals'] == null ? true : JsonClass.parseBool(map['equals']),
        value: map['value']?.toString(),
        variableName: map['variableName']!,
      );
    }

    return result;
  }

  /// Executes the step.  This will
  @override
  Future<void> execute({
    required CancelToken cancelToken,
    required TestReport report,
    required TestController tester,
  }) async {
    final value = tester.resolveVariable(this.value)?.toString();
    final variableName = tester.resolveVariable(this.variableName);
    assert(variableName?.isNotEmpty == true);

    final name = "$id('$variableName', '$value', '$equals', '$caseSensitive')";
    log(
      name,
      tester: tester,
    );

    var match = false;
    final actual = tester.resolveVariable('{{$variableName}}');
    if (equals ==
        (caseSensitive == true
            ? (actual?.toString() == value)
            : (actual?.toString().toLowerCase() ==
                value?.toString().toLowerCase()))) {
      match = true;
    }
    if (match != true) {
      throw Exception(
        'variableName: [$variableName] -- actualValue: [$actual] ${equals == true ? '!=' : '=='} [$value] (caseSensitive = [$caseSensitive]).',
      );
    }
  }

  @override
  String getBehaviorDrivenDescription(TestController tester) {
    var result = behaviorDrivenDescriptions[0];

    result = result.replaceAll(
      '{{caseSensitive}}',
      caseSensitive == true ? 'sensitive' : 'insensitive',
    );
    result = result.replaceAll(
      '{{equals}}',
      equals == true ? 'equal' : 'not equal',
    );
    result = result.replaceAll(
      '{{variableName}}',
      variableName,
    );

    result = result.replaceAll('{{value}}', value ?? 'null');

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
        'caseSensitive': caseSensitive,
        'equals': equals,
        'variableName': variableName,
        'value': value,
      };
}
