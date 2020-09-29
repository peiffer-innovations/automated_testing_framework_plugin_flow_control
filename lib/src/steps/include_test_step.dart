import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:meta/meta.dart';

/// Test step that allows to execute all the steps from another [Test].
class IncludeTestStep extends TestRunnerStep {
  IncludeTestStep({
    this.suiteName,
    @required this.testName,
  }) : assert(testName != null);

  final String suiteName;
  final String testName;

  /// Creates an instance from a JSON-like map structure.  This expects the
  /// following format:
  ///
  /// ```json
  /// {
  ///   "suiteName": <String>,
  ///   "testName": <String>
  /// }
  /// ```
  ///
  /// See also:
  /// * [TestStep.fromDynamic]
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

  /// Executes the step. This will first load all the tests through the
  /// [TestController] and then will filter the first [PendingTest] with the
  /// same [testName]. If there is at least one [PendingTest] that fit, this
  /// will iterate through the test's list of steps and will await the
  /// execution of each one. If not, this will throw an [Exception], failing the
  /// step.
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
          "include_test('$testName', '$suiteName') "
          'step: [${step.id}] -- executing step',
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
        'include_test: unable to find the test $testName '
        '${suiteName == null ? 'in any suite' : 'in suite $suiteName'}.',
      );
    }
  }

  /// Converts this to a JSON compatible map.  For a description of the format,
  /// see [fromDynamic].
  @override
  Map<String, dynamic> toJson() {
    return {
      'suiteName': suiteName,
      'testName': testName,
    };
  }
}
