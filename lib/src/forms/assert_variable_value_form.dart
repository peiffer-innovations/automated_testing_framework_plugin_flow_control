import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:automated_testing_framework_plugin_flow_control/automated_testing_framework_plugin_flow_control.dart';
import 'package:flutter/material.dart';
import 'package:form_validation/form_validation.dart';
import 'package:static_translations/static_translations.dart';

class AssertVariableValueForm extends TestStepForm {
  const AssertVariableValueForm();

  @override
  bool get supportsMinified => true;

  @override
  TranslationEntry get title =>
      TestFlowControlTranslations.atf_flow_title_assert_variable_value;

  @override
  Widget buildForm(
    BuildContext context,
    Map<String, dynamic> values, {
    bool minify = false,
  }) {
    var translator = Translator.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (minify != true)
          buildHelpSection(
            context,
            TestFlowControlTranslations.atf_flow_help_assert_variable_value,
            minify: minify,
          ),
        buildValuesSection(
          context,
          [
            buildEditText(
              context: context,
              id: 'key',
              label: TestFlowControlTranslations.atf_flow_form_key,
              validators: [
                RequiredValidator(),
              ],
              values: values,
            ),
            SizedBox(height: 16.0),
            buildEditText(
              context: context,
              id: 'value',
              label: TestStepTranslations.atf_form_value,
              validators: [
                RequiredValidator(),
              ],
              values: values,
            ),
            SizedBox(height: 24.0),
            TestStepPicker(
              label: translator.translate(
                TestFlowControlTranslations.atf_flow_form_when_false,
              ),
              onStepChanged: (step) => values['whenFalse'] = step?.toJson(),
              step: TestStep.fromDynamic(values['whenFalse']),
            ),
            SizedBox(height: 16.0),
            TestStepPicker(
              label: translator.translate(
                TestFlowControlTranslations.atf_flow_form_when_true,
              ),
              onStepChanged: (step) => values['whenTrue'] = step?.toJson(),
              step: TestStep.fromDynamic(values['whenTrue']),
            ),
          ],
          minify: minify,
        ),
      ],
    );
  }
}
