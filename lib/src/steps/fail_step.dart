import 'package:automated_testing_framework/automated_testing_framework.dart';

/// Test step that will always fail.
class FailStep extends TestRunnerStep {
  FailStep({
    this.message,
  });

  static const id = 'fail';

  static List<String> get behaviorDrivenDescriptions => List.unmodifiable([
        'fail the test.',
        'fail the test with the message "`{{message}}`".',
      ]);

  final String? message;

  @override
  String get stepId => id;

  /// Creates an instance from a JSON-like map structure.  This expects the
  /// following format:
  ///
  /// ```json
  /// {
  ///   "message": <String>
  /// }
  /// ```
  ///
  /// See also:
  /// * [TestStep.fromDynamic]
  static FailStep? fromDynamic(dynamic map) {
    FailStep? result;

    if (map != null) {
      result = FailStep(
        message: map['message'],
      );
    }

    return result;
  }

  /// Executes the step.  This will always fail.
  @override
  Future<void> execute({
    required CancelToken cancelToken,
    required TestReport report,
    required TestController tester,
  }) async {
    var name = "$id('$message')";
    log(
      name,
      tester: tester,
    );

    throw Exception(message ?? '<no message>');
  }

  @override
  String getBehaviorDrivenDescription(TestController tester) {
    var result = message == null
        ? behaviorDrivenDescriptions[0]
        : behaviorDrivenDescriptions[1];

    result = result.replaceAll('{{message}}', message ?? 'null');

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
        'message': message,
      };
}
