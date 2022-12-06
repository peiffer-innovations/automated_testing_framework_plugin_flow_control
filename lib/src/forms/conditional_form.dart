import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:automated_testing_framework_plugin_flow_control/automated_testing_framework_plugin_flow_control.dart';
import 'package:flutter/material.dart';
import 'package:form_validation/form_validation.dart';
import 'package:static_translations/static_translations.dart';

class ConditionalForm extends TestStepForm {
  const ConditionalForm();

  @override
  bool get supportsMinified => true;

  @override
  TranslationEntry get title =>
      TestFlowControlTranslations.atf_flow_title_conditional;

  @override
  Widget buildForm(
    BuildContext context,
    Map<String, dynamic>? values, {
    bool minify = false,
  }) {
    final translator = Translator.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (minify != true)
          buildHelpSection(
            context,
            TestFlowControlTranslations.atf_flow_help_conditional,
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
              id: 'value',
              label: TestStepTranslations.atf_form_value,
              validators: [
                RequiredValidator(),
              ],
              values: values,
            ),
            const SizedBox(height: 24.0),
            TestStepPicker(
              label: translator.translate(
                TestFlowControlTranslations.atf_flow_form_when_false,
              ),
              onStepChanged: (step) => values['whenFalse'] = step?.toJson(),
              step: TestStep.fromDynamicNullable(values['whenFalse']),
            ),
            const SizedBox(height: 16.0),
            TestStepPicker(
              label: translator.translate(
                TestFlowControlTranslations.atf_flow_form_when_true,
              ),
              onStepChanged: (step) => values['whenTrue'] = step?.toJson(),
              step: TestStep.fromDynamicNullable(values['whenTrue']),
            ),
          ],
          minify: minify,
        ),
      ],
    );
  }
}
