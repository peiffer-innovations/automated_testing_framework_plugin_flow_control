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
  TextEditingController testController = TextEditingController();
  TextEditingController suiteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getAvailableTests();
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: suiteController,
          decoration: InputDecoration(
            labelText: 'Suite Name', //TODO: Use translations
          ),
        ),
        TypeAheadFormField(
          autovalidate: true,
          hideOnEmpty: true,
          itemBuilder: (context, test) {
            return ListTile(
              //TODO: Use translations
              title: Text('Test: ${test.name}'),
              subtitle: Text('Suite: ${test.suiteName ?? ''}'),
            );
          },
          onSuggestionSelected: (test) {
            suiteController.text = test.suiteName;
            testController.text = test.name;
          },
          suggestionsCallback: (testName) {
            return _getSuggestionsFrom(testName: testName);
          },
          textFieldConfiguration: TextFieldConfiguration(
            controller: testController,
            decoration: InputDecoration(
              labelText: 'Test Name', //TODO: Use translations
            ),
          ),
          validator: (testName) => Validator(
            validators: [RequiredValidator()],
          ).validate(
            context: context,
            label: 'Test Name', //TODO: Use translations
            value: testName,
          ),
        ),
      ],
    );
  }

  Future<void> _getAvailableTests() async {
    var runner = TestRunner.of(context);
    var tests = await runner.controller.loadTests(context);
    tests.forEach(
      (test) => availableTests.add(test),
    );
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
}
