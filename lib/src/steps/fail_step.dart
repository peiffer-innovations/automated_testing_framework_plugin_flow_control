import 'package:automated_testing_framework/automated_testing_framework.dart';

/// Test step that will always fail.
class FailStep extends TestRunnerStep {
  FailStep({
    this.message,
  });

  final String? message;

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
    var name = "fail('$message')";
    log(
      name,
      tester: tester,
    );

    throw Exception(message ?? '<no message>');
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
