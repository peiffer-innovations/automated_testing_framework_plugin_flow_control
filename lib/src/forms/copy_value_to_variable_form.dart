import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:automated_testing_framework_plugin_flow_control/automated_testing_framework_plugin_flow_control.dart';
import 'package:flutter/material.dart';
import 'package:form_validation/form_validation.dart';
import 'package:static_translations/static_translations.dart';

class CopyValueToVariableForm extends TestStepForm {
  const CopyValueToVariableForm();

  @override
  bool get supportsMinified => true;

  @override
  TranslationEntry get title =>
      TestFlowControlTranslations.atf_flow_title_copy_value_to_variable;

  @override
  Widget buildForm(
    BuildContext context,
    Map<String, dynamic> values, {
    bool minify = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (minify != true)
          buildHelpSection(
            context,
            TestFlowControlTranslations.atf_flow_help_copy_value_to_variable,
            minify: minify,
          ),
        buildValuesSection(
          context,
          [
            buildEditText(
              context: context,
              id: 'testableId',
              label: TestStepTranslations.atf_form_widget_id,
              validators: [
                RequiredValidator(),
              ],
              values: values,
            ),
            SizedBox(height: 16.0),
            buildEditText(
              context: context,
              id: 'variableName',
              label: TestStepTranslations.atf_form_variable_name,
              validators: [RequiredValidator()],
              values: values,
            ),
            if (minify != true) ...[
              SizedBox(height: 16.0),
              buildTimeoutSection(
                context: context,
                values: values,
              ),
            ],
          ],
          minify: minify,
        ),
      ],
    );
  }
}
