import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:meta/meta.dart';

class MultiStepStep extends TestRunnerStep {
  MultiStepStep({
    @required this.steps,
  }) : assert(steps != null);

  final List<dynamic> steps;

  static MultiStepStep fromDynamic(dynamic map) {
    MultiStepStep result;

    if (map != null) {
      List stepsList = map['steps'] is List ? map['steps'] : [map['steps']];

      result = MultiStepStep(
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
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'steps': steps.map((step) {
        var result = step;
        if (step is Map) {
          result = '\n-\t${step['id']}';
        }
        return result;
      }),
    };
  }
}
