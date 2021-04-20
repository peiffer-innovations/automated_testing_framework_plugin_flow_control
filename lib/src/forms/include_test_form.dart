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
    Map<String, dynamic>? values, {
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
  _TestEditor({required this.values});

  final Map<String, dynamic>? values;

  @override
  _TestEditorState createState() => _TestEditorState();
}

class _TestEditorState extends State<_TestEditor> {
  late List<PendingTest> _availableTests;
  TextEditingController? _suiteController;
  TextEditingController? _testController;
  TextEditingController? _versionController;
  late Translator _translator;

  @override
  void initState() {
    super.initState();
    _initAvailableTests();
    _initTextControllers();
    _translator = Translator.of(context);
  }

  @override
  void dispose() {
    _suiteController!.dispose();
    _testController!.dispose();
    super.dispose();
  }

  Future<void> _initAvailableTests() async {
    _availableTests = [];
    var runner = TestRunner.of(context)!;
    var tests = await runner.controller!.loadTests(context);
    tests?.forEach(
      (test) => _availableTests.add(test),
    );
  }

  void _initTextControllers() {
    _suiteController = TextEditingController();
    _suiteController!.text = widget.values!['suiteName'];
    _suiteController!.addListener(() {
      _updateValues(
        widget.values!,
        suiteName: _suiteController!.text,
      );
    });

    _testController = TextEditingController();
    _testController!.text = widget.values!['testName'];
    _testController!.addListener(() {
      _updateValues(
        widget.values!,
        testName: _testController!.text,
      );
    });

    _versionController = TextEditingController();
    _versionController!.text = widget.values!['testVersion'];
    _versionController!.addListener(() {
      _updateValues(
        widget.values!,
        testVersion: _versionController!.text,
      );
    });
  }

  List<PendingTest> _getSuggestionsFrom({
    int limit = 4,
    required String editedTestName,
  }) {
    var highestVersions = <String, PendingTest>{};
    var patternInText = ({
      required String pattern,
      required String text,
    }) =>
        text.toLowerCase().contains(
              pattern.toLowerCase(),
            );

    _availableTests.forEach((test) {
      if (patternInText(pattern: editedTestName, text: test.name)) {
        var key = '${test.name}-${test.suiteName}';
        highestVersions.putIfAbsent(
          key,
          () => test,
        );

        if (highestVersions[key]!.version < test.version) {
          highestVersions[key] = test;
        }
      }
    });

    var result = highestVersions.values.take(limit).toList();
    return result;
  }

  void _updateValues(
    Map<String, dynamic> values, {
    String? suiteName,
    String? testName,
    String? testVersion,
  }) {
    values['suiteName'] =
        suiteName?.isNotEmpty != true ? values['suiteName'] : suiteName;
    values['testName'] =
        testName?.isNotEmpty != true ? values['testName'] : testName;
    values['testVersion'] =
        testVersion?.isNotEmpty != true ? values['testVersion'] : testVersion;
  }

  @override
  Widget build(BuildContext context) {
    var translatedSuiteName = _translator.translate(
      TestFlowControlTranslations.atf_flow_form_suite_name,
    );
    var translatedTestName = _translator.translate(
      TestFlowControlTranslations.atf_flow_form_test_name,
    );
    var translatedTestVersion = _translator.translate(
      TestFlowControlTranslations.atf_flow_form_test_version,
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
          autovalidateMode: AutovalidateMode.always,
          hideOnEmpty: true,
          itemBuilder: (context, dynamic test) => ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$translatedSuiteName: ${test.suiteName ?? ''}',
                ),
                Text(
                  '$translatedTestVersion: ${test.version}',
                ),
              ],
            ),
            title: Text(
              '$translatedTestName: ${test.name}',
            ),
          ),
          onSuggestionSelected: (dynamic test) {
            _suiteController!.text = test.suiteName;
            _testController!.text = test.name;
            _versionController!.text = test.version.toString();
          },
          suggestionsCallback: (editedTestName) => _getSuggestionsFrom(
            editedTestName: editedTestName,
          ),
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
        TextFormField(
          controller: _versionController,
          decoration: InputDecoration(
            labelText: translatedTestVersion,
          ),
        ),
      ],
    );
  }
}
