import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:automated_testing_framework_plugin_flow_control/automated_testing_framework_plugin_flow_control.dart';
import 'package:flutter/material.dart';
import 'package:form_validation/form_validation.dart';
import 'package:static_translations/static_translations.dart';

class ConditionalWidgetExistsForm extends TestStepForm {
  const ConditionalWidgetExistsForm();

  @override
  bool get supportsMinified => true;

  @override
  TranslationEntry get title =>
      TestFlowControlTranslations.atf_flow_title_conditional_widget_exists;

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
            TestFlowControlTranslations.atf_flow_help_conditional_widget_exists,
            minify: minify,
          ),
        buildValuesSection(
          context,
          [
            buildEditText(
              context: context,
              id: 'testableId',
              label: TestFlowControlTranslations.atf_flow_form_widget_id,
              validators: [
                RequiredValidator(),
              ],
              values: values!,
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
