import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:automated_testing_framework_plugin_flow_control/automated_testing_framework_plugin_flow_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:json_class/json_class.dart';
import 'package:static_translations/static_translations.dart';

class MultiStepForm extends TestStepForm {
  const MultiStepForm();

  @override
  bool get supportsMinified => true;

  @override
  TranslationEntry get title =>
      TestFlowControlTranslations.atf_flow_title_multi_step;

  @override
  Widget buildForm(
    BuildContext context,
    Map<String, dynamic> values, {
    bool minify = false,
  }) {
    /// If this line is removed, [values] will still have a reference to the
    /// original [steps] List, so modifying that here will modify it in the
    /// [TestStep] without confirmation.
    values['steps'] = List.from(values['steps'] ?? []);
    return Column(
      children: [
        if (minify != true)
          buildHelpSection(
            context,
            TestFlowControlTranslations.atf_flow_help_multi_step,
            minify: minify,
          ),
        buildValuesSection(
          context,
          [
            if (minify != true) ...[
              buildEditText(
                context: context,
                id: 'debugLabel',
                label: TestFlowControlTranslations
                    .atf_flow_form_multi_step_debug_label,
                values: values,
              ),
              SizedBox(height: 16.0),
            ],
            _StepsEditor(
              values: values,
            ),
          ],
        ),
      ],
    );
  }
}

class _StepsEditor extends StatefulWidget {
  _StepsEditor({@required this.values});

  final Map<String, dynamic> values;

  @override
  _StepsEditorState createState() => _StepsEditorState();
}

class _StepsEditorState extends State<_StepsEditor> {
  ScrollController _scrollController;
  List<TestStep> _steps;
  Translator _translator;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _steps = JsonClass.fromDynamicList(
          widget.values['steps'],
          (map) => TestStep.fromDynamic(map),
        ) ??
        [];
    _translator = Translator.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 300.0,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: IconTheme.of(context).color,
            ),
          ),
          child: _steps.isEmpty
              ? Center(
                  child: Text(
                    _translator.translate(
                      TestFlowControlTranslations
                          .atf_flow_form_multi_step_empty,
                    ),
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  itemCount: _steps.length,
                  itemBuilder: (context, index) {
                    return Row(
                      key: UniqueKey(),
                      children: [
                        Flexible(
                          child: TestStepPicker(
                            label: _translator.translate(
                              TestFlowControlTranslations.atf_flow_form_step,
                            ),
                            onStepChanged: (step) {
                              widget.values['steps'][index] = step?.toJson();
                              setState(() {
                                _steps[index] = step;
                              });
                            },
                            step: _steps[index],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            (widget.values['steps'] as List).removeAt(index);
                            setState(() {
                              _steps.removeAt(index);
                            });
                          },
                        ),
                      ],
                    );
                  },
                  controller: _scrollController,
                ),
        ),
        Divider(
          color: IconTheme.of(context).color,
        ),
        IconButton(
          onPressed: () {
            (widget.values['steps'] as List).add(null);
            setState(() {
              _steps.add(null);
            });
            SchedulerBinding.instance.addPostFrameCallback((_) {
              _scrollController.jumpTo(
                _scrollController.position.maxScrollExtent,
              );
            });
          },
          icon: Icon(Icons.add),
        ),
      ],
    );
  }
}
