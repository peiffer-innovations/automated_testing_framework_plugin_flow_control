**ARCHIVED**: This is no longer maintained to focus on other packages.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [automated_testing_framework_plugin_flow_control](#automated_testing_framework_plugin_flow_control)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Live Example](#live-example)
  - [Quick Start](#quick-start)
  - [Reserved Variables](#reserved-variables)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# automated_testing_framework_plugin_flow_control

## Table of Contents

* [Introduction](#introduction)
* [Live Example](#live-example)
* [Quick Start](#quick-start)
* [Reserved Variables](#reserved_variables)
* [Additional Test Steps](https://github.com/peiffer-innovations/automated_testing_framework_plugin_flow_control/blob/main/documentation/STEPS.md)


## Introduction

A series of test steps that are related to test flow control and test variables.  The core framework is designed to be easily used by non-developers for building and running tests.  Flow control and variables tend to be more advanced options which is why this is an optional add on to the framework.


## Live Example

* [Web](https://peiffer-innovations.github.io/automated_testing_framework_plugin_flow_control/web/#/)


## Quick Start

```dart
import 'package:automated_testing_framework_plugin_flow_control/automated_testing_framework_plugin_flow_control.dart';

void main() {
  TestFlowControlHelper.registerTestSteps();

  // rest of app initialization
  // ...
}
```

## Reserved Variables

The following table defines the reserved variables provided by the plugin that can be by appropriate tests:

Name              | Type      | Example       | Description
------------------|-----------|---------------|-------------
`_functionResult` | `dynamic` | `42`          | The result of from the `execute_variable_function` step when no `resultVariableName` is set.
`_iterateNum`     | `int`     | `1`           | The current iteration number from `iterate`.
`_repeatNum`      | `int`     | `1`           | The current iteration number from `repeat_until`.
`_retryNum`       | `int`     | `1`           | The number of retries the `retry_on_failure` step is currently on.  This value is only updated by the `retry_on_failure` step.
`_testableId`     | `String`  | `testable_id` | The id of the current testable matched by `for_each_testable`.

