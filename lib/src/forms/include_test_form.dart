import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:automated_testing_framework_plugin_flow_control/src/test_flow_control_translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:form_validation/form_validation.dart';
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
            minify: minify,
          ),
        buildValuesSection(
          context,
          [
            _TestEditor(
              values: values,
            ),
          ],
          minify: minify,
        ),
      ],
    );
  }
}

class _TestEditor extends StatefulWidget {
  _TestEditor({@required this.values});

  final Map<String, dynamic> values;

  @override
  _TestEditorState createState() => _TestEditorState();
}

class _TestEditorState extends State<_TestEditor> {
  List<PendingTest> _availableTests;
  TextEditingController _suiteController;
  TextEditingController _testController;
  Translator _translator;

  @override
  void initState() {
    super.initState();
    _initAvailableTests();
    _initTextControllers();
    _translator = Translator.of(context);
  }

  @override
  void dispose() {
    _suiteController.dispose();
    _testController.dispose();
    super.dispose();
  }

  Future<void> _initAvailableTests() async {
    _availableTests = [];
    var runner = TestRunner.of(context);
    var tests = await runner.controller.loadTests(context);
    tests.forEach(
      (test) => _availableTests.add(test),
    );
  }

  void _initTextControllers() {
    _suiteController = TextEditingController();
    _suiteController.text = widget.values['suiteName'];
    _suiteController.addListener(() {
      _updateValues(
        widget.values,
        suiteName: _suiteController.text,
      );
    });

    _testController = TextEditingController();
    _testController.text = widget.values['testName'];
    _testController.addListener(() {
      _updateValues(
        widget.values,
        testName: _testController.text,
      );
    });
  }

  List<PendingTest> _getSuggestionsFrom({
    int limit = 4,
    @required String testName,
  }) {
    var result = _availableTests
        .where(
          (test) {
            return test.name.toLowerCase().contains(
                  testName.toLowerCase(),
                );
          },
        )
        .take(limit)
        .toList();
    return result;
  }

  void _updateValues(
    Map<String, dynamic> values, {
    String suiteName,
    String testName,
  }) {
    values['suiteName'] =
        suiteName?.isNotEmpty != true ? values['suiteName'] : suiteName;
    values['testName'] =
        testName?.isNotEmpty != true ? values['testName'] : testName;
  }

  @override
  Widget build(BuildContext context) {
    var translatedSuiteName = _translator.translate(
      TestFlowControlTranslations.atf_flow_form_suite_name,
    );
    var translatedTestName = _translator.translate(
      TestFlowControlTranslations.atf_flow_form_test_name,
    );
    return Column(
      children: [
        TextFormField(
          controller: _suiteController,
          decoration: InputDecoration(
            labelText: translatedSuiteName,
          ),
        ),
        TypeAheadFormField(
          autovalidate: true,
          hideOnEmpty: true,
          itemBuilder: (context, test) {
            return ListTile(
              title: Text(
                '$translatedTestName: ${test.name}',
              ),
              subtitle: Text(
                '$translatedSuiteName: ${test.suiteName ?? ''}',
              ),
            );
          },
          onSuggestionSelected: (test) {
            _suiteController.text = test.suiteName;
            _testController.text = test.name;
          },
          suggestionsCallback: (editedTestName) {
            return _getSuggestionsFrom(testName: editedTestName);
          },
          textFieldConfiguration: TextFieldConfiguration(
            controller: _testController,
            decoration: InputDecoration(
              labelText: translatedTestName,
            ),
          ),
          validator: (editedTestName) => Validator(
            validators: [RequiredValidator()],
          ).validate(
            context: context,
            label: translatedTestName,
            value: editedTestName,
          ),
        ),
      ],
    );
  }
}
