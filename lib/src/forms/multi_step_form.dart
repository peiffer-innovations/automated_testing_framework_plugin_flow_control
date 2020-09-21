import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:automated_testing_framework_plugin_flow_control/automated_testing_framework_plugin_flow_control.dart';
import 'package:flutter/material.dart';
import 'package:static_translations/static_translations.dart';

class MultiStepForm extends TestStepForm {
  @override
  Widget buildForm(
    BuildContext context,
    Map<String, dynamic> values, {
    bool minify = false,
  }) {
    // TODO: MultiStep Form
    //var translator = Translator.of(context);
    return Column(
      children: [
        Text('TODO'),
      ],
    );
  }

  @override
  bool get supportsMinified => true;

  @override
  TranslationEntry get title =>
      TestFlowControlTranslations.atf_flow_title_multi_step;
}
