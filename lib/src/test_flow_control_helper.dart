import 'dart:convert';

import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:automated_testing_framework_plugin_flow_control/automated_testing_framework_plugin_flow_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validation/form_validation.dart';
import 'package:static_translations/static_translations.dart';

class TestFlowControlHelper {
  static Widget buildJsonEditText({
    @required BuildContext context,
    @required String id,
    String defaultValue,
    @required TranslationEntry label,
    List<ValueValidator> validators,
    @required Map<String, dynamic> values,
  }) {
    assert(context != null);
    assert(id?.isNotEmpty == true);
    assert(label != null);
    assert(values != null);

    if (values[id] == null && defaultValue != null) {
      values[id] = defaultValue;
    }

    var translator = Translator.of(context);
    var encoder = JsonEncoder.withIndent('  ');
    var initialValue = values[id]?.toString();
    if (initialValue?.isNotEmpty == true) {
      try {
        initialValue = encoder.convert(json.decode(initialValue));
      } catch (e) {
        // no-op
      }
    }

    return TextFormField(
      autovalidateMode: validators?.isNotEmpty == true
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      decoration: InputDecoration(
        labelText: translator.translate(label),
      ),
      initialValue: initialValue,
      maxLines: 5,
      onChanged: (value) {
        var encoded = '';

        try {
          encoded = json.encode(json.decode(value));
        } catch (e) {
          encoded = '';
        }
        values[id] = encoded;
      },
      onEditingComplete: () {},
      smartQuotesType: SmartQuotesType.disabled,
      validator: (value) => validators?.isNotEmpty == true
          ? Validator(validators: validators).validate(
              context: context,
              label: translator.translate(label),
              value: value,
            )
          : null,
    );
  }

  /// Registers the test steps to the optional [registry].  If not set, the
  /// default [TestStepRegistry] will be used.
  static void registerTestSteps([TestStepRegistry registry]) {
    (registry ?? TestStepRegistry.instance).registerCustomSteps([
      TestStepBuilder(
        availableTestStep: AvailableTestStep(
          form: AssertVariableValueForm(),
          help: TestFlowControlTranslations.atf_flow_help_assert_variable_value,
          id: 'assert_variable_value',
          keys: const {'caseSensitive', 'equals', 'value', 'variableName'},
          quickAddValues: null,
          title:
              TestFlowControlTranslations.atf_flow_title_assert_variable_value,
          widgetless: true,
          type: null,
        ),
        testRunnerStepBuilder: AssertVariableValueStep.fromDynamic,
      ),
      TestStepBuilder(
        availableTestStep: AvailableTestStep(
          form: ClearVariablesForm(),
          help: TestFlowControlTranslations.atf_flow_help_clear_variables,
          id: 'clear_variables',
          keys: const {},
          quickAddValues: const {},
          title: TestFlowControlTranslations.atf_flow_title_clear_variables,
          widgetless: true,
          type: null,
        ),
        testRunnerStepBuilder: ClearVariablesStep.fromDynamic,
      ),
      TestStepBuilder(
        availableTestStep: AvailableTestStep(
          form: ConditionalForm(),
          help: TestFlowControlTranslations.atf_flow_help_conditional,
          id: 'conditional',
          keys: const {'value', 'variableName', 'whenFalse', 'whenTrue'},
          quickAddValues: null,
          title: TestFlowControlTranslations.atf_flow_title_conditional,
          widgetless: true,
          type: null,
        ),
        testRunnerStepBuilder: ConditionalStep.fromDynamic,
      ),
      TestStepBuilder(
        availableTestStep: AvailableTestStep(
          form: ConditionalWidgetExistsForm(),
          help: TestFlowControlTranslations
              .atf_flow_help_conditional_widget_exists,
          id: 'conditional_widget_exists',
          keys: const {'testableId', 'whenFalse', 'whenTrue'},
          quickAddValues: null,
          title: TestFlowControlTranslations
              .atf_flow_title_conditional_widget_exists,
          widgetless: false,
          type: null,
        ),
        testRunnerStepBuilder: ConditionalWidgetExistsStep.fromDynamic,
      ),
      TestStepBuilder(
        availableTestStep: AvailableTestStep(
          form: CopyValueToVariableForm(),
          help:
              TestFlowControlTranslations.atf_flow_help_copy_value_to_variable,
          id: 'copy_value_to_variable',
          keys: const {'testableId', 'timeout', 'variableName'},
          quickAddValues: null,
          title:
              TestFlowControlTranslations.atf_flow_title_copy_value_to_variable,
          type: TestableType.value_requestable,
          widgetless: false,
        ),
        testRunnerStepBuilder: CopyValueToVariableStep.fromDynamic,
      ),
      TestStepBuilder(
        availableTestStep: AvailableTestStep(
          form: ExecuteVariableFunctionForm(),
          help: TestFlowControlTranslations
              .atf_flow_help_execute_variable_function,
          id: 'execute_variable_function',
          keys: const {'resultVariableName', 'variableName'},
          quickAddValues: null,
          title: TestFlowControlTranslations
              .atf_flow_title_execute_variable_function,
          widgetless: true,
        ),
        testRunnerStepBuilder: ExecuteVariableFunctionStep.fromDynamic,
      ),
      TestStepBuilder(
        availableTestStep: AvailableTestStep(
          form: ExpectFailureForm(),
          help: TestFlowControlTranslations.atf_flow_help_expect_failure,
          id: 'expect_failure',
          keys: const {'step'},
          quickAddValues: null,
          title: TestFlowControlTranslations.atf_flow_title_expect_failure,
          widgetless: true,
        ),
        testRunnerStepBuilder: ExpectFailureStep.fromDynamic,
      ),
      TestStepBuilder(
        availableTestStep: AvailableTestStep(
          form: FailForm(),
          help: TestFlowControlTranslations.atf_flow_help_fail,
          id: 'fail',
          keys: const {'message'},
          quickAddValues: {},
          title: TestFlowControlTranslations.atf_flow_title_fail,
          widgetless: true,
        ),
        testRunnerStepBuilder: FailStep.fromDynamic,
      ),
      TestStepBuilder(
        availableTestStep: AvailableTestStep(
          form: ForEachTestableForm(),
          help: TestFlowControlTranslations.atf_flow_help_for_each_testable,
          id: 'for_each_testable',
          keys: const {'regEx', 'step', 'variableName'},
          quickAddValues: null,
          title: TestFlowControlTranslations.atf_flow_title_for_each_testable,
          widgetless: true,
        ),
        testRunnerStepBuilder: ForEachTestableStep.fromDynamic,
      ),
      TestStepBuilder(
        availableTestStep: AvailableTestStep(
          form: IncludeTestForm(),
          help: TestFlowControlTranslations.atf_flow_help_include_test,
          id: 'include_test',
          keys: const {'suiteName', 'testName', 'testVersion'},
          quickAddValues: null,
          title: TestFlowControlTranslations.atf_flow_title_include_test,
          widgetless: true,
        ),
        testRunnerStepBuilder: IncludeTestStep.fromDynamic,
      ),
      TestStepBuilder(
        availableTestStep: AvailableTestStep(
          form: IncrementValueForm(),
          help: TestFlowControlTranslations.atf_flow_help_increment_value,
          id: 'increment_value',
          keys: const {'increment', 'variableName'},
          quickAddValues: {},
          title: TestFlowControlTranslations.atf_flow_title_increment_value,
          widgetless: true,
        ),
        testRunnerStepBuilder: IncrementValueStep.fromDynamic,
      ),
      TestStepBuilder(
        availableTestStep: AvailableTestStep(
          form: IterateForm(),
          help: TestFlowControlTranslations.atf_flow_help_iterate,
          id: 'iterate',
          keys: const {'end', 'start', 'step', 'variableName'},
          quickAddValues: null,
          title: TestFlowControlTranslations.atf_flow_title_iterate,
          widgetless: true,
        ),
        testRunnerStepBuilder: IterateStep.fromDynamic,
      ),
      TestStepBuilder(
        availableTestStep: AvailableTestStep(
          form: MultiStepForm(),
          help: TestFlowControlTranslations.atf_flow_help_multi_step,
          id: 'multi_step',
          keys: const {'debugLabel', 'steps'},
          quickAddValues: null,
          title: TestFlowControlTranslations.atf_flow_title_multi_step,
          type: null,
          widgetless: true,
        ),
        testRunnerStepBuilder: MultiStepStep.fromDynamic,
      ),
      TestStepBuilder(
        availableTestStep: AvailableTestStep(
          form: RepeatUntilForm(),
          help: TestFlowControlTranslations.atf_flow_help_repeat_until,
          id: 'repeat_until',
          keys: const {
            'counterVariableName',
            'maxIterations',
            'step',
            'value',
            'variableName'
          },
          quickAddValues: null,
          title: TestFlowControlTranslations.atf_flow_title_repeat_until,
          type: null,
          widgetless: true,
        ),
        testRunnerStepBuilder: RepeatUntilStep.fromDynamic,
      ),
      TestStepBuilder(
        availableTestStep: AvailableTestStep(
          form: RetryOnFailureForm(),
          help: TestFlowControlTranslations.atf_flow_help_retry_on_failure,
          id: 'retry_on_failure',
          keys: const {'retryCount', 'step'},
          quickAddValues: null,
          title: TestFlowControlTranslations.atf_flow_title_retry_on_failure,
          type: null,
          widgetless: true,
        ),
        testRunnerStepBuilder: RetryOnFailureStep.fromDynamic,
      ),
    ]);
  }
}
