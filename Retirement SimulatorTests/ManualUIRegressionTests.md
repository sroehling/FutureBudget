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

## Background Forecast Results Generation

###Setup

1. Populate the app with a reasonably sized budget. The budget setup from FutureBudgetManualUITesting.ods is a good candidate.
2. Change the forecast results time frame to span 99 years, the maximum.

### Test Initial Results Get Generated with App Startup

1. Startup the app
2. Immediately change views to the forecast view.

The forecast should show as being generated with a progress view which grays out the underlying view.

### Test Changes to Input Generate a New Forecast

1. Startup the app and go to the "What If" view.
2. Go to the enabled inputs view and toggle the enabled status for one of the inputs.
3. Go to the forecast view.

After toggling the enabled flag for an input, the forecast results should automatically start generating, and update the view when complete.

### Test Changes to Budget

1. Create a second budget
2. Toggle to the second budget
3. Navigate to the forecast view.

The forecast view should update to show the results from the second budget. You should be able to toggle back and see the results from the first budget. Changing the budget should also make the forecast view toggle back to the results list (from the chart or graph).

## Account Deletion With Transfers

When a budget includes a transfer into or out of an account, the app should prevent deletion of the account.

1. Create an account.
2. Create a Transfer from Cash to the account
3. Create a Transfer from the account to Cash
4. Try to delete the account, you should be prevented from doing so.
5. Delete the first transfer.
6. Try to delete the account, you should be prevented from doing so.
7. Delete the second transfer. 
8. Try to delete the account, you be able to delete the account at this point.
