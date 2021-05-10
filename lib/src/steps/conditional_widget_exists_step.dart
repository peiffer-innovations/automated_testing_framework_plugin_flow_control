import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:flutter/material.dart';

/// Test step that will execute the [whenTrue] or [whenFalse] sub-step based on
/// whether a Widget with a [ValueKey] with a value of [testableId] exists on
/// the widget tree.  This does not support a delay, it will immediately execute
/// the [whenTrue] or [whenFalse] based on whether the Widget does or does not
/// exist at the time of the start of this step.  If the Widget may not
/// immediately be on the tree, utilize the [SleepStep] to add the delay before
/// executing this.
class ConditionalWidgetExistsStep extends TestRunnerStep {
  ConditionalWidgetExistsStep({
    required this.testableId,
    this.whenFalse,
    this.whenTrue,
  });

  static const id = 'conditional_widget_exists';

  final String testableId;
  final dynamic whenFalse;
  final dynamic whenTrue;

  @override
  String get stepId => id;

  /// Creates an instance from a JSON-like map structure.  This expects the
  /// following format:
  ///
  /// ```json
  /// {
  ///   "testableId": <String>,
  ///   "whenFalse": <TestStep>,
  ///   "whenTrue": <TestStep>
  /// }
  /// ```
  ///
  /// See also:
  /// * [TestStep.fromDynamic]
  static ConditionalWidgetExistsStep? fromDynamic(dynamic map) {
    ConditionalWidgetExistsStep? result;

    if (map != null) {
      result = ConditionalWidgetExistsStep(
        testableId: map['testableId'],
        whenFalse: map['whenFalse'],
        whenTrue: map['whenTrue'],
      );
    }

    return result;
  }

  /// Executes the step.  This will execute the [whenTrue] or [whenFalse] based
  /// on whether a Widget with a [ValueKey] containing the [testableId] exists
  /// on the widget tree when this executes.
  @override
  Future<void> execute({
    required CancelToken cancelToken,
    required TestReport report,
    required TestController tester,
  }) async {
    var whenFalse = tester.resolveVariable(this.whenFalse);
    var whenTrue = tester.resolveVariable(this.whenTrue);
    String testableId = tester.resolveVariable(this.testableId);
    assert(testableId.isNotEmpty == true);

    var name = "$id('$testableId')";
    log(
      name,
      tester: tester,
    );

    TestStep? step;

    var widgetExists =
        find.byKey(ValueKey<String?>(testableId)).evaluate().isNotEmpty == true;
    var resultStep = widgetExists == true ? whenTrue : whenFalse;
    if (resultStep != null) {
      step = TestStep.fromDynamic(resultStep);
    }

    if (step == null) {
      log(
        'conditional_widget_exists: exists: [$widgetExists] -- no step',
        tester: tester,
      );
    } else {
      log(
        'conditional_widget_exists: exists: [$widgetExists] -- executing step',
        tester: tester,
      );
      await tester.executeStep(
        cancelToken: cancelToken,
        report: report,
        step: step,
        subStep: true,
      );
    }
  }

  /// Converts this to a JSON compatible map.  For a description of the format,
  /// see [fromDynamic].
  @override
  Map<String, dynamic> toJson() => {
        'testableId': testableId,
        'whenTrue': whenTrue,
        'whenFalse': whenFalse,
      };
}
