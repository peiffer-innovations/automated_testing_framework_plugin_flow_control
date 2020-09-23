# Test Steps

## Table of Contents

* [Introduction](#introduction)
* [Test Step Summary](#test-step-summary)
* [Details](#details)
  * [assert_variable_value](#assert_variable_value)
  * [clear_variables](#clear_variables)
  * [conditional](#conditional)
  * [copy_value_to_variable](#copy_value_to_variable)
  * [expect_failure](#expect_failure)
  * [fail](#fail)


## Introduction

This plugin provides a few new [Test Steps](https://github.com/peiffer-innovations/automated_testing_framework/blob/main/documentation/STEPS.md) related to test flow control actions.


---

## Test Step Summary

Test Step IDs                                     | Description
--------------------------------------------------|-------------
[assert_variable_value](#assert_variable_value)   | Asserts the value on the on a `variableName` equals the `value`.
[clear_variables](#clear_variables)               | Clears all the variables from the `TestController`.
[conditional](#conditional)                       | Conditionally executes a step based on the `value` of a `variableName`.
[copy_value_to_variable](#copy_value_to_variable) | Copies the value from the `Testable` to the `variableName`.
[expect_failure](#expect_failure)                 | Passes if, and only if, the sub-step throws an error / fails.


---
## Details


### assert_variable_value

**How it Works**

1. Gets the value from `variableName` and compares it to the one on the `TestController`.  This will fail if one of the follosing is true:
    1. The `equals` is `true` or undefined and the Document's value does not match the `value`.
    2. The `equals` is `false` Document's value does match the `error`.


**Example**

```json
{
  "id": "assert_variable_value",
  "image": "<optional_base_64_image>",
  "values": {
    "equals": true,
    "value": "myExpectedValue",
    "variableName": "myVariableName"
  }
}
```

**Values**

Key            | Type    | Required | Supports Variable | Description
---------------|---------|----------|-------------------|-------------
`equals`       | boolean | No       | No                | Defines whether the Document's value must equal the `value` or must not equal the `value`.  Defaults to `true` if not defined.
`value`        | String  | Yes      | Yes               | The value to evaluate against.
`variableName` | String  | Yes      | Yes               | The `variableName` to check the value for.


---

### clear_variables

**How it Works**

1. Clears all variables from the `TestController`.

**Example**

```json
{
  "id": "clear_variables",
  "image": "<optional_base_64_image>",
  "values": {}
}
```

**Values**

n/a


---

### conditional

**How it Works**

1. Gets the value from the `variableName` from the `TestController`.
2. Compares the value to `value`.
    1. If they are equal, and `whenTrue` is set, the step defined in `whenTrue` will execute.
    1. If they are not equal, and `whenFalse` is set, the step defined in `whenFalse` will execute.

**Example**

```json
{
  "id": "conditional",
  "image": "<optional_base_64_image>",
  "values": {
    "value": "myExpectedValue",
    "variableName": "myVariableName",
    "whenFalse": {
      "id": "test_step_id",
      "values": {
        "testStep": "values"
      }
    },
    "whenTrue": {
      "id": "test_step_id",
      "values": {
        "testStep": "values"
      }
    }
  }
}
```

**Values**

Key            | Type   | Required | Supports Variable | Description
---------------|--------|----------|-------------------|-------------
`value`        | String | No       | Yes               | The value to compare the `variableName`'s value to.
`variableName` | String | Yes      | Yes               | The `variableName` to get the value for.
`whenFalse`    | Map    | No       | Yes               | The step to execute when the value on the step and the `variableName`'s values are not equal.
`whenTrue`     | Map    | No       | Yes               | The step to execute when the value on the step and the `variableName`'s values are equal.


---


### copy_value_to_variable

**How it Works**

1. Looks for the `Testable` on the widget tree.  If not found before `timeout` the step will fail.
2. Copies the value from the `Testable` to the `variableName`.

**Example**

```json
{
  "id": "copy_value_to_variable",
  "image": "<optional_base_64_image>",
  "values": {
    "testableId": "my-text-id",
    "timeout": 10,
    "variableName": "myVariableName"
  }
}
```

**Values**

Key            | Type    | Required | Supports Variable | Description
---------------|---------|----------|-------------------|-------------
`testableId`   | String  | Yes      | Yes               | The `id` of the `Testable` to evaluate the value.
`timeout`      | integer | No       | Yes               | Number of seconds the step will wait for the `Testable` widget to be available on the widget tree.
`variableName` | String  | Yes      | No                | The value to evaluate against.


---

### expect_failure

**How it Works**

1. Executes the `step`.
2. Passes if, and only if, the `step` results in a failure.

**Example**

```json
{
  "id": "expect_failure",
  "image": "<optional_base_64_image>",
  "values": {
    "step": {
      "id": "failing_test_step",
      "values": {
        "testStep": "values"
      }
    }
  }
}
```

**Values**

Key    | Type   | Required | Supports Variable | Description
-------|--------|----------|-------------------|-------------
`step` | Map    | Yes      | Yes               | The step to execute when the value on the step and the `variableName`'s values are equal.


---

### fail

**How it Works**

1. Fails the step with the optional `message`.

**Example**

```json
{
  "id": "fail",
  "image": "<optional_base_64_image>",
  "values": {
    "message": "Well... crap... :("
  }
}
```

**Values**

Key       | Type   | Required | Supports Variable | Description
----------|--------|----------|-------------------|-------------
`message` | String | Yes      | Yes               | The step to execute when the value on the step and the `variableName`'s values are equal.


