import 'dart:async';

import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:automated_testing_framework_plugin_flow_control/src/test_flow_control_translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:static_translations/static_translations.dart';

class IncludeTestForm extends TestStepForm {
  @override
  bool get supportsMinified => true;

  @override
  TranslationEntry get title =>
      TestFlowControlTranslations.atf_flow_title_include_test;

  @override
  Widget buildForm(
    BuildContext context,
    Map<String, dynamic> values, {
    bool minify = false,
  }) {
    return Column(
      children: [
        if (minify != true)
          buildHelpSection(
            context,
            TestFlowControlTranslations.atf_flow_help_include_test,
          ),
        buildValuesSection(
          context,
          [
            _TestEditor(),
          ],
        ),
      ],
    );
  }
}

class _TestEditor extends StatefulWidget {
  @override
  _TestEditorState createState() => _TestEditorState();
}

class _TestEditorState extends State<_TestEditor> {
  List<String> availableTests = [];
  bool testsWereLoaded = false;

  @override
  void initState() {
    super.initState();
    _getAvailableTests();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        enabled: testsWereLoaded,
      ),
      suggestionsCallback: (pattern) {
        return _getSuggestionsFrom(pattern, 3);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      onSuggestionSelected: (suggestion) {
        //print(suggestion);
      },
    );
  }

  Future<void> _getAvailableTests() async {
    var runner = TestRunner.of(context);
    var tests = await runner.controller.loadTests(context);
    tests.forEach(
      (test) => availableTests.add(test.name),
    );
    setState(() {
      testsWereLoaded = true;
    });
    //print(availableTests);
  }

  List<String> _getSuggestionsFrom(String pattern, int limit) {
    var result = availableTests
        .where(
          (test) => test.toLowerCase().contains(pattern),
        )
        .take(limit)
        .toList();

    return result;
  }
}
