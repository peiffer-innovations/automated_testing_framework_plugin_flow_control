import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:meta/meta.dart';

class MultiStepStep extends TestRunnerStep {
  MultiStepStep({
    this.name,
    @required this.steps,
  }) : assert(steps != null);

  final String name;
  final List<dynamic> steps;

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

  @override
  Future<void> execute({
    TestReport report,
    TestController tester,
  }) async {
    log(
      'MultiStep: Starting execution of $name',
      tester: tester,
    );
    for (var rawStep in steps) {
      var stepMap = tester.resolveVariable(rawStep);
      var step = tester.registry.getRunnerStep(
        id: stepMap['id'],
        values: stepMap['values'],
      );

      if (step == null) {
        log(
          'MultiStep: step: [${stepMap['id']}] -- no step',
          tester: tester,
        );
      } else {
        log(
          'MultiStep: step: [${stepMap['id']}] -- executing step',
          tester: tester,
        );
        await step.execute(
          report: report,
          tester: tester,
        );
      }
    }
    log(
      'MultiStep: Finished execution of $name',
      tester: tester,
    );
  }

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
