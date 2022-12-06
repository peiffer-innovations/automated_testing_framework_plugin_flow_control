import 'dart:math' as math;

import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:json_class/json_class.dart';

/// Test step that allows to execute all the steps from another [Test].
class IncludeTestStep extends TestRunnerStep {
  IncludeTestStep({
    this.suiteName,
    required this.testName,
    this.testVersion,
  });

  static const id = 'include_test';

  static List<String> get behaviorDrivenDescriptions => List.unmodifiable([
        'include the test in the `{{suiteName}}` suite named `{{testName}}` using version number `{{testVersion}}`.',
        'include the test named `{{testName}}` using version number `{{testVersion}}`.',
        'include the test in the `{{suiteName}}` suite named `{{testName}}` using the latest version.',
        'include the test named `{{testName}}` using the latest version.',
      ]);

  final String? suiteName;
  final String testName;
  final String? testVersion;

  @override
  String get stepId => id;

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
  static IncludeTestStep? fromDynamic(dynamic map) {
    IncludeTestStep? result;

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
    required CancelToken cancelToken,
    required TestReport report,
    required TestController tester,
  }) async {
    final suiteName = tester.resolveVariable(this.suiteName);
    final testName = tester.resolveVariable(this.testName);
    final testVersion = JsonClass.parseInt(
      tester.resolveVariable(this.testVersion),
    );

    final name = "$id('$testName', '$testVersion', '$suiteName')";

    log(
      name,
      tester: tester,
    );

    final suiteTests = await tester.loadTests(
      null,
      suiteName: suiteName,
    );

    final namedTests = <PendingTest>[];
    int? version;

    suiteTests?.forEach((test) {
      if (test.name == testName) {
        namedTests.add(test);
        version = math.max(test.version, version ?? -1);
      }
    });

    version = testVersion ?? version;

    final pendingTest = namedTests.firstWhereOrNull(
      (test) => test.version == version,
    );

    if (pendingTest != null) {
      if (cancelToken.cancelled == true) {
        throw Exception('[CANCELLED]: the step has been cancelled.');
      }
      final test = await pendingTest.loader.load(ignoreImages: true);
      for (var step in test.steps) {
        if (cancelToken.cancelled == true) {
          throw Exception('[CANCELLED]: the step has been cancelled.');
        }
        log(
          '$name step: [${step.id}] -- executing step',
          tester: tester,
        );
        await tester.executeStep(
          cancelToken: cancelToken,
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

  @override
  String getBehaviorDrivenDescription(TestController tester) {
    String result;

    if (testVersion == null) {
      if (suiteName == null) {
        result = behaviorDrivenDescriptions[3];
      } else {
        result = behaviorDrivenDescriptions[2];
      }
    } else {
      if (suiteName == null) {
        result = behaviorDrivenDescriptions[1];
      } else {
        result = behaviorDrivenDescriptions[0];
      }
    }

    result = result.replaceAll('{{suiteName}}', suiteName ?? 'null');
    result = result.replaceAll('{{testName}}', testName);
    result = result.replaceAll('{{testVersion}}', testVersion ?? 'null');
    ;

    return result;
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
