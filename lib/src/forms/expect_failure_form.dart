import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:automated_testing_framework_plugin_flow_control/automated_testing_framework_plugin_flow_control.dart';
import 'package:flutter/material.dart';
import 'package:static_translations/static_translations.dart';

class ExpectFailureForm extends TestStepForm {
  const ExpectFailureForm();

  @override
  bool get supportsMinified => true;

  @override
  TranslationEntry get title =>
      TestFlowControlTranslations.atf_flow_title_expect_failure;

  @override
  Widget buildForm(
    BuildContext context,
    Map<String, dynamic>? values, {
    bool minify = false,
  }) {
    var translator = Translator.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (minify != true)
          buildHelpSection(
            context,
            TestFlowControlTranslations.atf_flow_help_expect_failure,
            minify: minify,
          ),
        buildValuesSection(
          context,
          [
            TestStepPicker(
              label: translator.translate(
                TestFlowControlTranslations.atf_flow_form_step,
              ),
              onStepChanged: (step) => values!['step'] = step?.toJson(),
              step: TestStep.fromDynamic(values!['step']),
            ),
          ],
          minify: minify,
        ),
      ],
    );
  }
}
