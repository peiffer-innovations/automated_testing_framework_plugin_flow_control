# Test Steps

## Table of Contents

* [Introduction](#introduction)
* [Test Step Summary](#test-step-summary)
* [Details](#details)
  * [assert_variable_value](#assert_variable_value)
  * [clear_variables](#clear_variables)
  * [conditional](#conditional)
  * [conditional_widget_exists](#conditional_widget_exists)
  * [copy_value_to_variable](#copy_value_to_variable)
  * [execute_variable_function](#execute_variable_function)
  * [expect_failure](#expect_failure)
  * [fail](#fail)
  * [for_each_testable](#for_each_testable)
  * [include_test](#include_test)
  * [increment_value](#increment_value)
  * [iterate](#iterate)
  * [multi_step](#multi_step)
  * [repeat_until](#repeat_until)
  * [retry_on_failure](#retry_on_failure)


## Introduction

This plugin provides a few new [Test Steps](https://github.com/peiffer-innovations/automated_testing_framework/blob/main/documentation/STEPS.md) related to test flow control actions.


---

## Test Step Summary

Test Step IDs                                           | Description
--------------------------------------------------------|-------------
[assert_variable_value](#assert_variable_value)         | Asserts the value on the on a `variableName` equals the `value`.
[clear_variables](#clear_variables)                     | Clears all the variables from the `TestController`.
[conditional](#conditional)                             | Conditionally executes a step based on the `value` of a `variableName`.
[conditional_widget_exists](#conditional_widget_exists) | Conditionally executes a step based whether or not the `testableId` exists on the tree.
[copy_value_to_variable](#copy_value_to_variable)       | Copies the value from the `Testable` to the `variableName`.
[execute_variable_function](#execute_variable_function) | Locates the `TestVariableFunction` in the `TestController` using `variableName`, executes it, and stores the result in `resultVariableName`.
[expect_failure](#expect_failure)                       | Passes if, and only if, the sub-step throws an error / fails.
[fail](#fail)                                           | Fails the step and, if set, passes along the optional `message`.
[for_each_testable](#for_each_testable)                 | Iterates through each `Testable` on the active widget tree, sets the id to `variableName` and then executes the associated `step`.
[include_test](#include_test)                           | Import and execute all the steps from another test given its name, version and suite.
[increment_value](#increment_value)                     | Increments a particular `variableName` by a defined `increment`.
[iterate](#iterate)                                     | Iterates from `start` to `end` - 1 executing the `step` each time.
[multi_step](#multi_step)                               | Groups different test steps to be executed.
[repeat_until](#repeat_until)                           | Repeats the `step` until the `variableName` equals the `value`.
[retry_on_failure](#retry_on_failure)                   | Retries the `step` if it fails up to `retryCount` times.


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

### conditional_widget_exists

**How it Works**

1. Immediate looks for the Widget with a `ValueKey` of `widgetId` on the Widget Tree.  If the Widget is a `Testable` and the `widgetId` matches the `id` of the `Testable`, that too will be a match.
    1. If the widget exists, and `whenTrue` is set, the step defined in `whenTrue` will execute.
    1. If they widget does not exist, and `whenFalse` is set, the step defined in `whenFalse` will execute.

**Example**

```json
{
  "id": "conditional_widget_exists",
  "image": "<optional_base_64_image>",
  "values": {
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
    },
    "widgetId": "myWidgetValueKeyValue"
  }
}
```

**Values**

Key            | Type   | Required | Supports Variable | Description
---------------|--------|----------|-------------------|-------------
`testableId`   | String | No       | Yes               | The value in a `ValueKey` to look for on a Widget.  May also match the `id` of a `Testable`.
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

### execute_variable_function

**How it Works**

1. Gets the `TestVariableFunction` from the `TestController` using the `variableName`.  Fails if not found.
2. Executes the function and stores the result in `resultVariableName`, or `_functionResult` if not defined.

**Example**

```json
{
  "id": "execute_variable_function",
  "image": "<optional_base_64_image>",
  "values": {
    "resultVariableName": "outputVariableName",
    "variableName": "functionVariableName"
    }
  }
}
```

**Values**

Key                  | Type   | Required | Supports Variable | Description
---------------------|--------|----------|-------------------|-------------
`resultVariableName` | String | No       | Yes               | The variable to store the result of the executed function.  Will be `_functionResult` if omitted.
`variableName`       | String | Yes      | No                | The variable name to look for the `TestVariableFunction` to execute.


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


### for_each_testable

**How it Works**

1. Locates every active `Testable` with an `id` that matches the `regEx`.
2. Iterates through each entity found in step 1, sets the value of `variableName`, or "_testableId" if omitted, to the `id` of the current `Testable`.
3. Executes the `step`.

**Example**

```json
{
  "id": "for_each_testable",
  "image": "<optional_base_64_image>",
  "values": {
    "regEx": ".*",
    "step": {
      "id": "step_for_testable",
      "values": {
        "testStep": "values"
      }
    },
    "variableName": "myVariableName"
  }
}
```

**Values**

Key            | Type    | Required | Supports Variable | Description
---------------|---------|----------|-------------------|-------------
`regEx`        | String  | Yes      | Yes               | The pattern to use when matching `Testable` widget id's.
`step`         | Map     | Yes      | Yes               | The `TestStep` to execute for each matched `Testable`.
`variableName` | String  | Yes      | Yes               | The variable to store the current id of the current `Testable` in before executing the `step`.


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


### iterate

**How it Works**

1. Starts with the `start` value, or `0` if not set.
2. Iterates until `end` - 1.
3. Executes the `step` with each iteration.
4. Stores the current iteration value in `variableName` or `_iterateNum` if not set.

**Example**

```json
{
  "id": "iterate",
  "image": "<optional_base_64_image>",
  "values": {
    "end": 5,
    "start": 0,
    "step": {
      "id": "iterating_test_step",
      "values": {
        "testStep": "values"
      }
    },
    "variableName": "myVariableName"
  }
}
```

**Values**

Key            | Type    | Required | Supports Variable | Description
---------------|---------|----------|-------------------|-------------
`end`          | integer | Yes      | Yes               | The ending value.
`start`        | integer | No       | Yes               | The starting value. Defaults to `0`.
`step`         | Map     | Yes      | Yes               | The step to execute with each iteration.
`variableName` | String  | Yes      | Yes               | The variable to to store the current increment value.  Defaults to `_iterateNum`.


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


### repeat_until

**How it Works**

1. Executes the `step` until the `variableName` equals the given `value`.
2. If `maxIterations` is set, this step will fail if it executes `maxIterations` times.
3. Stores the current iteration counter in `counterVariableName` or `_repeatNumber` if not set.

**Example**

```json
{
  "id": "repeat_until",
  "image": "<optional_base_64_image>",
  "values": {
    "counterVariableName": "myCounterVariable",
    "maxIterations": 100,
    "step": {
      "id": "repeating_test_step",
      "values": {
        "testStep": "values"
      }
    },
    "value": "myEndingValue",
    "variableName": "myVariableName"
  }
}
```

**Values**

Key                   | Type    | Required | Supports Variable | Description
----------------------|---------|----------|-------------------|-------------
`counterVariableName` | String  | Yes      | Yes               | The variable to to store the current increment value.  Defaults to `_repeatNum`.  Zero based.
`maxIterations`       | integer | No       | Yes               | The maximum number of iterations before aborting and failing.
`step`                | Map     | Yes      | Yes               | The step to execute with each iteration.
`value`               | String  | Yes      | Yes               | The value to look for to stop the iterations.
`variableName`        | String  | Yes      | Yes               | The variable to read while looking for `value`.


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


