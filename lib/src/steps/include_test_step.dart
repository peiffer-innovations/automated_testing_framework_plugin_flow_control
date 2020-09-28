import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:meta/meta.dart';

class IncludeTestStep extends TestRunnerStep {
  IncludeTestStep({
    this.suiteName,
    @required this.testName,
  }) : assert(testName != null);

  final String suiteName;
  final String testName;

  static IncludeTestStep fromDynamic(dynamic map) {
    IncludeTestStep result;

    if (map != null) {
      result = IncludeTestStep(
        suiteName: map['suiteName'],
        testName: map['testName'],
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
      "include_test('$testName', '$suiteName')",
      tester: tester,
    );

    var suiteTests = await tester.loadTests(
      null,
      suiteName: suiteName,
    );
    var pendingTest = suiteTests.firstWhere(
      (element) => element.name == testName,
      orElse: () => null,
    );

    if (pendingTest != null) {
      var test = await pendingTest.loader.load(ignoreImages: true);
      for (var step in test.steps) {
        log(
          "include_test('$testName', '$suiteName') step: [${step.id}] -- executing step",
          tester: tester,
        );
        await tester.executeStep(
          report: report,
          step: step,
          subStep: true,
        );
      }
    } else {
      throw Exception(
        'include_test: unable to find the test $testName ${suiteName == null ? 'in any suite' : 'in suite $suiteName'}.',
      );
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'suiteName': suiteName,
      'testName': testName,
    };
  }
}
