import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:automated_testing_framework_plugin_flow_control/automated_testing_framework_plugin_flow_control.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('', () {});

  test('assert_variable_value', () {
    TestFlowControlHelper.registerTestSteps();
    var availStep = TestStepRegistry.instance.getAvailableTestStep(
      'assert_variable_value',
    );

    expect(availStep.form.runtimeType, AssertVariableValueForm);
    expect(
      availStep.help,
      TestFlowControlTranslations.atf_flow_help_assert_variable_value,
    );
    expect(availStep.id, 'assert_variable_value');
    expect(
      availStep.title,
      TestFlowControlTranslations.atf_flow_title_assert_variable_value,
    );
    expect(availStep.type, null);
    expect(availStep.widgetless, true);
  });

  test('clear_variables', () {
    TestFlowControlHelper.registerTestSteps();
    var availStep = TestStepRegistry.instance.getAvailableTestStep(
      'clear_variables',
    );

    expect(availStep.form.runtimeType, ClearVariablesForm);
    expect(
      availStep.help,
      TestFlowControlTranslations.atf_flow_help_clear_variables,
    );
    expect(availStep.id, 'clear_variables');
    expect(
      availStep.title,
      TestFlowControlTranslations.atf_flow_title_clear_variables,
    );
    expect(availStep.type, null);
    expect(availStep.widgetless, true);
  });

  test('conditional', () {
    TestFlowControlHelper.registerTestSteps();
    var availStep = TestStepRegistry.instance.getAvailableTestStep(
      'conditional',
    );

    expect(availStep.form.runtimeType, ConditionalForm);
    expect(
      availStep.help,
      TestFlowControlTranslations.atf_flow_help_conditional,
    );
    expect(availStep.id, 'conditional');
    expect(
      availStep.title,
      TestFlowControlTranslations.atf_flow_title_conditional,
    );
    expect(availStep.type, null);
    expect(availStep.widgetless, true);
  });

  test('copy_value_to_variable', () {
    TestFlowControlHelper.registerTestSteps();
    var availStep = TestStepRegistry.instance.getAvailableTestStep(
      'copy_value_to_variable',
    );

    expect(availStep.form.runtimeType, CopyValueToVariableForm);
    expect(
      availStep.help,
      TestFlowControlTranslations.atf_flow_help_copy_value_to_variable,
    );
    expect(availStep.id, 'copy_value_to_variable');
    expect(
      availStep.title,
      TestFlowControlTranslations.atf_flow_title_copy_value_to_variable,
    );
    expect(availStep.type, TestableType.value_requestable);
    expect(availStep.widgetless, false);
  });

  test('execute_variable_function', () {
    TestFlowControlHelper.registerTestSteps();
    var availStep = TestStepRegistry.instance.getAvailableTestStep(
      'execute_variable_function',
    );

    expect(availStep.form.runtimeType, ExecuteVariableFunctionForm);
    expect(
      availStep.help,
      TestFlowControlTranslations.atf_flow_help_execute_variable_function,
    );
    expect(availStep.id, 'execute_variable_function');
    expect(
      availStep.title,
      TestFlowControlTranslations.atf_flow_title_execute_variable_function,
    );
    expect(availStep.type, null);
    expect(availStep.widgetless, true);
  });

  test('expect_failure', () {
    TestFlowControlHelper.registerTestSteps();
    var availStep = TestStepRegistry.instance.getAvailableTestStep(
      'expect_failure',
    );

    expect(availStep.form.runtimeType, ExpectFailureForm);
    expect(
      availStep.help,
      TestFlowControlTranslations.atf_flow_help_expect_failure,
    );
    expect(availStep.id, 'expect_failure');
    expect(
      availStep.title,
      TestFlowControlTranslations.atf_flow_title_expect_failure,
    );
    expect(availStep.type, null);
    expect(availStep.widgetless, true);
  });

  test('include_test', () {
    TestFlowControlHelper.registerTestSteps();
    var availStep = TestStepRegistry.instance.getAvailableTestStep(
      'include_test',
    );

    expect(availStep.form.runtimeType, IncludeTestForm);
    expect(
      availStep.help,
      TestFlowControlTranslations.atf_flow_help_include_test,
    );
    expect(availStep.id, 'include_test');
    expect(
      availStep.title,
      TestFlowControlTranslations.atf_flow_title_include_test,
    );
    expect(availStep.type, null);
    expect(availStep.widgetless, true);
  });

  test('increment_value', () {
    TestFlowControlHelper.registerTestSteps();
    var availStep = TestStepRegistry.instance.getAvailableTestStep(
      'increment_value',
    );

    expect(availStep.form.runtimeType, IncrementValueForm);
    expect(
      availStep.help,
      TestFlowControlTranslations.atf_flow_help_increment_value,
    );
    expect(availStep.id, 'increment_value');
    expect(
      availStep.title,
      TestFlowControlTranslations.atf_flow_title_increment_value,
    );
    expect(availStep.type, null);
    expect(availStep.widgetless, true);
  });

  test('iterate', () {
    TestFlowControlHelper.registerTestSteps();
    var availStep = TestStepRegistry.instance.getAvailableTestStep(
      'iterate',
    );

    expect(availStep.form.runtimeType, IterateForm);
    expect(
      availStep.help,
      TestFlowControlTranslations.atf_flow_help_iterate,
    );
    expect(availStep.id, 'iterate');
    expect(
      availStep.title,
      TestFlowControlTranslations.atf_flow_title_iterate,
    );
    expect(availStep.type, null);
    expect(availStep.widgetless, true);
  });
  test('multi_step', () {
    TestFlowControlHelper.registerTestSteps();
    var availStep = TestStepRegistry.instance.getAvailableTestStep(
      'multi_step',
    );

    expect(availStep.form.runtimeType, MultiStepForm);
    expect(
      availStep.help,
      TestFlowControlTranslations.atf_flow_help_multi_step,
    );
    expect(availStep.id, 'multi_step');
    expect(
      availStep.title,
      TestFlowControlTranslations.atf_flow_title_multi_step,
    );
    expect(availStep.type, null);
    expect(availStep.widgetless, true);
  });
}
