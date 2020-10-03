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
  * [include_test](#include_test)
  * [increment_value](#increment_value)
  * [multi_step](#multi_step)
  * [retry_on_failure](#retry_on_failure)


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
[fail](#fail)                                     | Fails the step and, if set, passes along the optional `message`.
[include_test](#include_test)                     | Import and execute all the steps from another test given its name, version and suite.
[increment_value](#increment_value)               | Increments a particular `variableName` by a defined `increment`.
[multi_step](#multi_step)                         | Groups different test steps to be executed.
[retry_on_failure](#retry_on_failure)             | Retries the `step` if it fails up to `retryCount` times.


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
`message` | String | Yes      | Yes               | The optional message to fail with.


---

### include_test

**How it Works**

1. Import and execute all the steps from another test given its name, version and suite.

**Example**

```json
{
  "id": "include_test",
  "image": "<optional_base_64_image>",
  "values": {
    "suiteName": "<optional_string>",
    "testName": "myTestName",
    "testVersion": "<optional_int>"
  }
}
```

**Values**

Key          | Type    | Required | Supports Variable | Description
-------------|---------|----------|-------------------|-------------
`suiteName`  | String  | No       | Yes               | The optional suite to which the `testName` belongs.
`testName`   | String  | Yes      | Yes               | The name of the test to import.
`testVersion`| integer | No       | Yes               | The optional version of the `testName`. If omitted, the version will be set to the highest available.


---


### increment_value

**How it Works**

1. Looks for a variable with the given `variableName`.
2. If found, attempts to increment that value by `increment` (or 1 if not set).
3. If not found, or the current value cannot be parsed to an int, sets the value to `0`.

**Example**

```json
{
  "id": "increment_value",
  "image": "<optional_base_64_image>",
  "values": {
    "increment": 1,
    "variableName": "myVariableName"
  }
}
```

**Values**

Key            | Type    | Required | Supports Variable | Description
---------------|---------|----------|-------------------|-------------
`increment`    | integer | No       | Yes               | The value to increment with, defaults to 1 if not set.
`variableName` | String  | Yes      | Yes               | The variable to increment.  If it doesn't exist, is is not currently parsable as an `int`, it will be reset to 0 and further calls to the `increment_value` will start incrementing it.


---

### multi_step

**How it Works**

1. Groups different test steps to be executed.

**Example**

```json
{
  "id": "multi_step",
  "image": "<optional_base_64_image>",
  "values": {
    "debugLabel": "<optional_string>",
    "steps": [
      {
        "id": "go_back",
        "values": {}
      },
      {
        "id": "tap",
        "values": {
          "testableId": "other_testable_widget"
        }
      }
    ]
  }
}
```

**Values**

Key         | Type   | Required | Supports Variable | Description
----------  |--------|----------|-------------------|-------------
`debugLabel`| String | No       | No                | The optional debug label of the `multi_step` step.
`steps`     | List   | Yes      | Only on each step | The list of steps to be executed as part of the same group.


---

### retry_on_failure

**How it Works**

1. Retries a `step` up to `retryCount`.
2. Will retry only if `step` fails.
3. Passes if, and only if, the `step` passes at least once.

**Example**

```json
{
  "id": "retry_on_failure",
  "image": "<optional_base_64_image>",
  "values": {
    "retryCount": "<int>",
    "step": {
      "id": "assert_variable_value",
      "values": {
        "variableName": "_retryNum",
        "value": "5"
      }
    }    
  }
}
```

**Values**

Key         | Type   | Required | Supports Variable | Description
----------  |--------|----------|-------------------|-------------
`retryCount`| int    | No       | Yes               | Number of times to retry the `step` if it fails.
`step`      | Map    | Yes      | Yes               | The step to execute, and potentially retry.


