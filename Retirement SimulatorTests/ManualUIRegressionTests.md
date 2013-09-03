# Manual FutureBudget UI Regression Tests

## Fixed Simulation Date with Different Value under Alternate Scenario

1. Create an Expense Input called "Test Expense"
2. Setup all the values to something well-defined (the actual values don't matter).
3. Save the expense.
4. Create an alternate Scenario called "Alternate" (or similar name).
5. Select the new alternate scenaro.
6. Go back to "Test Expense" and change the fixed start date to something different.

After saving the new fixed start date, it should show as being selected in Date selection/edit view. This test sequence previously caused an assertion because only the value displayed for the fixed date was being changed, not the assignedField property of the SelectableObjectTableEditViewController.

This issue was fixed in ResultraGenericLib commit with SHA: e67e6045d829e7ef6e35d007d983930917d614bb