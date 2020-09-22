import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:automated_testing_framework_plugin_flow_control/automated_testing_framework_plugin_flow_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:static_translations/static_translations.dart';

class MultiStepForm extends TestStepForm {
  @override
  Widget buildForm(
    BuildContext context,
    Map<String, dynamic> values, {
    bool minify = false,
  }) {
    // TODO: MultiStep Form
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
            _StepsEditor(
              values: values,
            )
          ],
        ),
      ],
    );
  }

  @override
  bool get supportsMinified => true;

  @override
  TranslationEntry get title =>
      TestFlowControlTranslations.atf_flow_title_multi_step;
}

class _StepsEditor extends StatefulWidget {
  _StepsEditor({@required this.values});

  final Map<String, dynamic> values;

  @override
  _StepsEditorState createState() => _StepsEditorState();
}

class _StepsEditorState extends State<_StepsEditor> {
  ScrollController scrollController;
  List<TestStep> steps = [];
  Translator translator;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    widget.values['steps'] ??= [];
    steps = (widget.values['steps'] as List)
        .map((rawStep) => TestStep.fromDynamic(rawStep))
        .toList();
    translator = Translator.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(
              color: IconTheme.of(context).color,
            ),
          ),
          child: ListView.builder(
            itemCount: steps.length,
            itemBuilder: (context, index) {
              return Row(
                key: UniqueKey(),
                children: [
                  Flexible(
                    child: TestStepPicker(
                      label: translator.translate(
                        TestFlowControlTranslations.atf_flow_form_inner_step,
                      ),
                      onStepChanged: (step) {
                        widget.values['steps'][index] = step?.toJson();
                        setState(() {
                          steps[index] = step;
                        });
                      },
                      step: steps[index],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      (widget.values['steps'] as List).removeAt(index);
                      setState(() {
                        steps.removeAt(index);
                      });
                    },
                  ),
                ],
              );
            },
            controller: scrollController,
          ),
        ),
        Divider(
          color: IconTheme.of(context).color,
        ),
        IconButton(
          onPressed: () {
            (widget.values['steps'] as List).add(null);
            setState(() {
              steps.add(null);
            });
            SchedulerBinding.instance.addPostFrameCallback((_) {
              scrollController.jumpTo(
                scrollController.position.maxScrollExtent,
              );
            });
          },
          icon: Icon(Icons.add),
        ),
      ],
    );
  }
}
