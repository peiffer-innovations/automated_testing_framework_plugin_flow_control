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
    expect(availStep.help,
        TestFlowControlTranslations.atf_flow_help_assert_variable_value);
    expect(availStep.id, 'assert_variable_value');
    expect(availStep.title,
        TestFlowControlTranslations.atf_flow_title_assert_variable_value);
    expect(availStep.type, null);
    expect(availStep.widgetless, true);
  });

  test('clear_variables', () {
    TestFlowControlHelper.registerTestSteps();
    var availStep = TestStepRegistry.instance.getAvailableTestStep(
      'clear_variables',
    );

    expect(availStep.form.runtimeType, ClearVariablesForm);
    expect(availStep.help,
        TestFlowControlTranslations.atf_flow_help_clear_variables);
    expect(availStep.id, 'clear_variables');
    expect(availStep.title,
        TestFlowControlTranslations.atf_flow_title_clear_variables);
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
        availStep.help, TestFlowControlTranslations.atf_flow_help_conditional);
    expect(availStep.id, 'conditional');
    expect(availStep.title,
        TestFlowControlTranslations.atf_flow_title_conditional);
    expect(availStep.type, null);
    expect(availStep.widgetless, true);
  });

  test('copy_value_to_variable', () {
    TestFlowControlHelper.registerTestSteps();
    var availStep = TestStepRegistry.instance.getAvailableTestStep(
      'copy_value_to_variable',
    );

    expect(availStep.form.runtimeType, CopyValueToVariableForm);
    expect(availStep.help,
        TestFlowControlTranslations.atf_flow_help_copy_value_to_variable);
    expect(availStep.id, 'copy_value_to_variable');
    expect(availStep.title,
        TestFlowControlTranslations.atf_flow_title_copy_value_to_variable);
    expect(availStep.type, TestableType.value_requestable);
    expect(availStep.widgetless, false);
  });

  test('multi_step', () {
    TestFlowControlHelper.registerTestSteps();
    var availStep = TestStepRegistry.instance.getAvailableTestStep(
      'multi_step',
    );

    expect(availStep.form.runtimeType, MultiStepForm);
    expect(
        availStep.help, TestFlowControlTranslations.atf_flow_help_multi_step);
    expect(availStep.id, 'multi_step');
    expect(
        availStep.title, TestFlowControlTranslations.atf_flow_title_multi_step);
    expect(availStep.type, null);
    expect(availStep.widgetless, true);
  });
}
