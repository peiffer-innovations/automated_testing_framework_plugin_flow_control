import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:automated_testing_framework_plugin_flow_control/automated_testing_framework_plugin_flow_control.dart';
import 'package:flutter/material.dart';
import 'package:static_translations/static_translations.dart';

class CancelTestForm extends TestStepForm {
  const CancelTestForm();

  @override
  bool get supportsMinified => false;

  @override
  TranslationEntry get title =>
      TestFlowControlTranslations.atf_flow_title_cancel_test;

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
            TestFlowControlTranslations.atf_flow_help_cancel_test,
            minify: minify,
          ),
      ],
    );
  }
}
