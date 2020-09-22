import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:logging/logging.dart';
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
  ///   "steps": <List>
  /// }
  /// ```
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
      'MultiStep: Starting execution of $name',
      tester: tester,
    );
    var logger = Logger('TestController');

    for (var rawStep in steps) {
      var stepMap = tester.resolveVariable(rawStep);
      var step = tester.registry.getRunnerStep(
        id: stepMap['id'],
        values: stepMap['values'],
      );

      try {
        if (step == null) {
          log(
            'MultiStep $name: step: [${stepMap['id']}] -- no step',
            tester: tester,
          );
        } else {
          log(
            'MultiStep $name: step: [${stepMap['id']}] -- executing step',
            tester: tester,
          );
          await step.execute(
            report: report,
            tester: tester,
          );
        }
      } catch (e, stack) {
        logger.severe(
          'Error running test step: ${stepMap['id']} as part of MultiStep $name',
          e,
          stack,
        );
        rethrow;
      }
    }
    log(
      'MultiStep: Finished execution of $name',
      tester: tester,
    );
  }

  /// Converts this to a JSON compatible map.  For a description of the format,
  /// see [fromDynamic].
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'steps': steps.map((step) {
        var result = step;
        if (step is Map) {
          result = '\n-\t${step['id']}';
        }
        return result;
      }).toList(),
    };
  }
}
