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
          ),
        buildValuesSection(
          context,
          [
            _TestEditor(
              values: values,
            ),
          ],
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
  List<PendingTest> availableTests = [];
  TextEditingController suiteController = TextEditingController();
  TextEditingController testController = TextEditingController();
  Translator translator;

  @override
  void initState() {
    super.initState();
    _setAvailableTests();
    _initTextControllers();
    translator = Translator.of(context);
  }

  @override
  void dispose() {
    suiteController.dispose();
    testController.dispose();
    super.dispose();
  }

  Future<void> _setAvailableTests() async {
    var runner = TestRunner.of(context);
    var tests = await runner.controller.loadTests(context);
    tests.forEach(
      (test) => availableTests.add(test),
    );
  }

  void _initTextControllers() {
    suiteController.text = widget.values['suiteName'];
    suiteController.addListener(() {
      _updateValues(
        widget.values,
        suiteName: suiteController.text,
      );
    });

    testController.text = widget.values['testName'];
    testController.addListener(() {
      _updateValues(
        widget.values,
        testName: testController.text,
      );
    });
  }

  List<PendingTest> _getSuggestionsFrom({
    int limit = 3,
    @required String testName,
  }) {
    var result = availableTests
        .where(
          (test) => test.name.toLowerCase().contains(testName.toLowerCase()),
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
    var translatedSuiteName = translator.translate(
      TestFlowControlTranslations.atf_flow_form_suite_name,
    );
    var translatedTestName = translator.translate(
      TestFlowControlTranslations.atf_flow_form_test_name,
    );
    return Column(
      children: [
        TextFormField(
          controller: suiteController,
          decoration: InputDecoration(
            labelText: translatedSuiteName,
          ),
        ),
        TypeAheadFormField(
          autovalidate: true,
          hideOnEmpty: true,
          itemBuilder: (context, test) {
            return ListTile(
              title: Text('$translatedTestName: ${test.name}'),
              subtitle: Text('$translatedSuiteName: ${test.suiteName ?? ''}'),
            );
          },
          onSuggestionSelected: (test) {
            suiteController.text = test.suiteName;
            testController.text = test.name;
          },
          suggestionsCallback: (editedTestName) {
            return _getSuggestionsFrom(testName: editedTestName);
          },
          textFieldConfiguration: TextFieldConfiguration(
            controller: testController,
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
