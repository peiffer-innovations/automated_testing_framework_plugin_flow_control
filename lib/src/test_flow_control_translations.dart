import 'package:static_translations/static_translations.dart';

class TestFlowControlTranslations {
  static const atf_flow_error_start_less_end = TranslationEntry(
    key: 'atf_flow_error_start_less_end',
    value: 'Start must be less than end.',
  );

  static const atf_flow_form_counter_variable_name = TranslationEntry(
    key: 'atf_flow_form_counter_variable_name',
    value: 'Counter Variable Name',
  );

  static const atf_flow_form_end = TranslationEntry(
    key: 'atf_flow_form_end',
    value: 'End',
  );

  static const atf_flow_form_increment = TranslationEntry(
    key: 'atf_flow_form_increment',
    value: 'Increment',
  );

  static const atf_flow_form_max_iterations = TranslationEntry(
    key: 'atf_flow_form_max_iterations',
    value: 'Max Iterations',
  );

  static const atf_flow_form_message = TranslationEntry(
    key: 'atf_flow_form_message',
    value: 'Message',
  );

  static const atf_flow_form_multi_step_empty = TranslationEntry(
    key: 'atf_flow_form_multi_step_empty',
    value: 'There are currently no Steps as part of this multi_step',
  );

  static const atf_flow_form_multi_step_debug_label = TranslationEntry(
    key: 'atf_flow_form_multi_step_debug_label',
    value: 'Debug Label',
  );

  static const atf_flow_form_matching_reg_ex = TranslationEntry(
    key: 'atf_flow_form_matching_reg_ex',
    value: 'Matching RegEx',
  );

  static const atf_flow_form_result_variable_name = TranslationEntry(
    key: 'atf_flow_form_result_variable_name',
    value: 'Result Variable Name',
  );

  static const atf_flow_form_retry_count = TranslationEntry(
    key: 'atf_flow_form_retry_count',
    value: 'Retry Count',
  );

  static const atf_flow_form_start = TranslationEntry(
    key: 'atf_flow_form_start',
    value: 'Start',
  );

  static const atf_flow_form_step = TranslationEntry(
    key: 'atf_flow_form_step',
    value: 'Step',
  );

  static const atf_flow_form_suite_name = TranslationEntry(
    key: 'atf_flow_form_suite_name',
    value: 'Suite Name',
  );

  static const atf_flow_form_test_name = TranslationEntry(
    key: 'atf_flow_form_test_name',
    value: 'Test Name',
  );

  static const atf_flow_form_test_version = TranslationEntry(
    key: 'atf_flow_form_test_version',
    value: 'Test Version',
  );

  static const atf_flow_form_when_false = TranslationEntry(
    key: 'atf_flow_form_when_false',
    value: 'False Step',
  );

  static const atf_flow_form_when_true = TranslationEntry(
    key: 'atf_flow_form_when_true',
    value: 'True Step',
  );

  static const atf_flow_form_widget_id = TranslationEntry(
    key: 'atf_flow_form_widget_id',
    value: 'Widget ID',
  );

  static const atf_flow_help_assert_variable_value = TranslationEntry(
    key: 'atf_flow_help_assert_variable_value',
    value:
        'Asserts the variable name does or does not contain a specific value.',
  );

  static const atf_flow_help_clear_variables = TranslationEntry(
    key: 'atf_flow_help_clear_variables',
    value: 'Clear all the variables from the test controller.',
  );

  static const atf_flow_help_conditional = TranslationEntry(
    key: 'atf_flow_help_conditional',
    value:
        'Conditional that will execute the next step based on whether this evaluates to true or false.',
  );

  static const atf_flow_help_conditional_widget_exists = TranslationEntry(
    key: 'atf_flow_help_conditional_widget_exists',
    value:
        'Conditional that will execute the next step based on whether the widget with the given id exists or not.  As a note, the widget id can be a Testable, but it may also be any widget with a ValueKey of the given widget id.',
  );

  static const atf_flow_help_copy_value_to_variable = TranslationEntry(
    key: 'atf_flow_help_copy_value_to_variable',
    value: 'Copies the value from the given Testable to a variable.',
  );

  static const atf_flow_help_expect_failure = TranslationEntry(
    key: 'atf_flow_help_expect_failure',
    value:
        'Expects that the sub-step results in a failed result.  Otherwise, this step itself will fail.',
  );

  static const atf_flow_help_execute_variable_function = TranslationEntry(
    key: 'atf_flow_help_execute_variable_function',
    value:
        'Gets the TestVariableFunction function from the given variable name, executes it, and then stores the result in the result variable name (or _functionResult if not defined).',
  );

  static const atf_flow_help_fail = TranslationEntry(
    key: 'atf_flow_help_fail',
    value: 'Fails a test with an optional message.',
  );

  static const atf_flow_help_for_each_testable = TranslationEntry(
    key: 'atf_flow_help_for_each_testable',
    value:
        'Iterates through each active testable on the tree that matches the set RegEx pattern, sets that testable id in the given variable name, and then executes the associated step.',
  );

  static const atf_flow_help_include_test = TranslationEntry(
    key: 'atf_flow_help_include_test',
    value:
        'Includes all the steps from one test given its name and suite. The test will be searched through all suites when Suite Name is empty.',
  );

  static const atf_flow_help_increment_value = TranslationEntry(
    key: 'atf_flow_help_increment_value',
    value: 'Increments the variable name by the given increment value.',
  );

  static const atf_flow_help_iterate = TranslationEntry(
    key: 'atf_flow_help_iterate',
    value:
        'Iterates from the starting value to the end - 1.  Stores the current value in the counter variable name.  Calls the step with each iteration.',
  );

  static const atf_flow_help_multi_step = TranslationEntry(
    key: 'atf_flow_help_multi_step',
    value: 'A group of test steps to be executed. It can contain zero tests.',
  );

  static const atf_flow_help_repeat_until = TranslationEntry(
    key: 'atf_flow_help_repeat_until',
    value:
        'Repeats the step until the value in the set variable name equals the required value.  Optionally allows a maximum number of repeats before aborting and failing.  Also optionally allows a counter variable name to be provided to store the current iteration number.',
  );

  static const atf_flow_help_retry_on_failure = TranslationEntry(
    key: 'atf_flow_help_retry_on_failure',
    value:
        'Expects that the sub-step results in a failed result.  Otherwise, this step itself will fail.',
  );

  static const atf_flow_title_assert_variable_value = TranslationEntry(
    key: 'atf_flow_title_assert_variable_value',
    value: 'Assert Variable Value',
  );

  static const atf_flow_title_clear_variables = TranslationEntry(
    key: 'atf_flow_title_clear_variables',
    value: 'Clear Variables',
  );

  static const atf_flow_title_conditional = TranslationEntry(
    key: 'atf_flow_title_conditional',
    value: 'Conditional',
  );

  static const atf_flow_title_conditional_widget_exists = TranslationEntry(
    key: 'atf_flow_title_conditional_widget_exists',
    value: 'Conditional Widget Exists',
  );

  static const atf_flow_title_copy_value_to_variable = TranslationEntry(
    key: 'atf_flow_title_copy_value_to_variable',
    value: 'Copy Value to Variable',
  );

  static const atf_flow_title_expect_failure = TranslationEntry(
    key: 'atf_flow_title_expect_failure',
    value: 'Expect Failure',
  );

  static const atf_flow_title_execute_variable_function = TranslationEntry(
    key: 'atf_flow_title_execute_variable_function',
    value: 'Execute Variable Function',
  );

  static const atf_flow_title_fail = TranslationEntry(
    key: 'atf_flow_title_fail',
    value: 'Fail',
  );

  static const atf_flow_title_for_each_testable = TranslationEntry(
    key: 'atf_flow_title_for_each_testable',
    value: 'For Each Testable',
  );

  static const atf_flow_title_include_test = TranslationEntry(
    key: 'atf_flow_title_include_test',
    value: 'Include Test',
  );

  static const atf_flow_title_increment_value = TranslationEntry(
    key: 'atf_flow_title_increment_value',
    value: 'Increment Value',
  );

  static const atf_flow_title_iterate = TranslationEntry(
    key: 'atf_flow_title_iterate',
    value: 'Iterate',
  );

  static const atf_flow_title_multi_step = TranslationEntry(
    key: 'atf_flow_title_multi_step',
    value: 'Multi Step',
  );

  static const atf_flow_title_repeat_until = TranslationEntry(
    key: 'atf_flow_title_repeat_until',
    value: 'Repeat Until',
  );

  static const atf_flow_title_retry_on_failure = TranslationEntry(
    key: 'atf_flow_title_retry_on_failure',
    value: 'Retry on Failure',
  );
}
