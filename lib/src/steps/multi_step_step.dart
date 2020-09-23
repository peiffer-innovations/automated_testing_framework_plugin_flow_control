import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:json_class/json_class.dart';
import 'package:meta/meta.dart';

/// Test step that groups different [TestStep] to be executed
/// as a block.
class MultiStepStep extends TestRunnerStep {
  MultiStepStep({
    this.name,
    @required this.steps,
  }) : assert(steps != null);

  final String name;
  final List<dynamic> steps;

  /// Creates an instance from a JSON-like map structure.  This expects the
  /// following format:
  ///
  /// ```json
  /// {
  ///   "name": <String>,
  ///   "steps": <List<TestStep>>
  /// }
  /// ```
  ///
  /// See also:
  /// * [TestStep.fromDynamic]
  static MultiStepStep fromDynamic(dynamic map) {
    MultiStepStep result;

    if (map != null) {
      var name = map['name'] ?? 'Default MultiStep';
      List stepsList = map['steps'] is List ? map['steps'] : [map['steps']];

      result = MultiStepStep(
        name: name,
        steps: stepsList
          ..removeWhere(
            (step) => step == null,
          ),
      );
    }

    return result;
  }

  /// Executes the step. This will iterate through the List of steps
  /// and will await the execution of each one.
  @override
  Future<void> execute({
    TestReport report,
    TestController tester,
  }) async {
    log(
      'multi_step: Starting execution of $name',
      tester: tester,
    );

    for (var rawStep in steps) {
      var stepMap = tester.resolveVariable(rawStep);
      var step = TestStep.fromDynamic(stepMap);

      if (step == null) {
        log(
          'multi_step $name: step: [${stepMap['id']}] -- no step',
          tester: tester,
        );
      } else {
        log(
          'multi_step $name: step: [${stepMap['id']}] -- executing step',
          tester: tester,
        );
        await tester.executeStep(
          report: report,
          step: step,
        );
      }
    }
    log(
      'multi_step: Finished execution of $name',
      tester: tester,
    );
  }

  /// Converts this to a JSON compatible map.  For a description of the format,
  /// see [fromDynamic].
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'steps': JsonClass.toJsonList(steps),
    };
  }
}
