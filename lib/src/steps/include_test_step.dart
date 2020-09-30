import 'dart:math' as math;

import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:json_class/json_class.dart';
import 'package:meta/meta.dart';

/// Test step that allows to execute all the steps from another [Test].
class IncludeTestStep extends TestRunnerStep {
  IncludeTestStep({
    this.suiteName,
    @required this.testName,
    this.testVersion,
  }) : assert(testName != null);

  final String suiteName;
  final String testName;
  final String testVersion;

  /// Creates an instance from a JSON-like map structure.  This expects the
  /// following format:
  ///
  /// ```json
  /// {
  ///   "suiteName": <String>,
  ///   "testName": <String>,
  ///   "testVersion": <int>
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
        testVersion: map['testVersion'],
      );
    }

    return result;
  }

  /// Executes the step. This will first load all the tests belonging to
  /// [suiteName] through the [TestController] and then will filter the first
  /// [PendingTest] with the same [testName] and [testVersion]. Also, if
  /// [testVersion] is null the filter will look up for the highest existent
  /// version of the [testName]. If there is at least one [PendingTest] that
  /// fit, this will iterate through the test's list of steps and will await
  /// the execution of each one. If not, this will throw an [Exception],
  /// failing the step.
  @override
  Future<void> execute({
    TestReport report,
    TestController tester,
  }) async {
    String suiteName = tester.resolveVariable(this.suiteName);
    String testName = tester.resolveVariable(this.testName);
    var testVersion = JsonClass.parseInt(
      tester.resolveVariable(this.testVersion),
    );

    var name = "include_test('$testName', '$testVersion', '$suiteName')";

    log(
      name,
      tester: tester,
    );

    var suiteTests = await tester.loadTests(
      null,
      suiteName: suiteName,
    );

    var namedTests = <PendingTest>[];
    int version;

    suiteTests.forEach((test) {
      if (test.name == testName) {
        namedTests.add(test);
        version = math.max(test.version, version ?? -1);
      }
    });

    version = testVersion ?? version;

    var pendingTest = namedTests.firstWhere(
      (test) => test.version == version,
      orElse: () => null,
    );

    if (pendingTest != null) {
      var test = await pendingTest.loader.load(ignoreImages: true);
      for (var step in test.steps) {
        log(
          '$name step: [${step.id}] -- executing step',
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
        'include_test: unable to find the test '
        '$testName with version $version '
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
      'testVersion': testVersion,
    };
  }
}
