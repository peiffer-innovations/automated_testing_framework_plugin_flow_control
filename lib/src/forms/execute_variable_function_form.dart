import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:automated_testing_framework_plugin_flow_control/automated_testing_framework_plugin_flow_control.dart';
import 'package:flutter/material.dart';
import 'package:form_validation/form_validation.dart';
import 'package:static_translations/static_translations.dart';

class ExecuteVariableFunctionForm extends TestStepForm {
  const ExecuteVariableFunctionForm();

  @override
  bool get supportsMinified => true;

  @override
  TranslationEntry get title =>
      TestFlowControlTranslations.atf_flow_title_execute_variable_function;

  @override
  Widget buildForm(
    BuildContext context,
    Map<String, dynamic>? values, {
    bool minify = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (minify != true)
          buildHelpSection(
            context,
            TestFlowControlTranslations.atf_flow_help_execute_variable_function,
            minify: minify,
          ),
        buildValuesSection(
          context,
          [
            buildEditText(
              context: context,
              id: 'variableName',
              label: TestStepTranslations.atf_form_variable_name,
              validators: [
                RequiredValidator(),
              ],
              values: values!,
            ),
            const SizedBox(height: 16.0),
            buildEditText(
              context: context,
              id: 'resultVariableName',
              label: TestFlowControlTranslations
                  .atf_flow_form_result_variable_name,
              values: values,
            ),
          ],
          minify: minify,
        ),
      ],
    );
  }
}
