## Tax Examples

When first creating inputs for [housing][housingExample] and [income][incomeExample], it is suggested to represent these items as single [income][income] or [expense][expense] inputs, such as "Take Home Pay" or "Mortgage Payment". An expense input like "Take Home Pay" would already have the tax payments factored in. Similarly, a "Mortgage Payment" expense input would the loan payment, property taxes, insurance.

Similarly, it is recommended to start with simplified [tax inputs][tax], then add more details when and if other inputs become more detailed or the long term results are sensitive to tax calculations. 

### Effective Tax Rate

Instead of initially creating separate tax inputs for different taxes like federal, state, and investment gains, a single tax input can be created to represent the expected combined or "effective" tax percentage. A tax input called "Effective Taxes" would be linked with appropriate income and account inputs. Deductions, credits and adjustments would not be considered in this case. 

In the end, the results may not be overly sensitive to the overall tax percentage, so starting with an effective tax rate may suffice for long term budgeting and planning purposes. In this case, representing taxes in more detail would be overkill. One experiment to determine the sensitivity of long term results to the overall tax rate would be to set the effective tax rate to a lower and higher number, then compare the long term results.

Starting with an effective tax rate is also a good way to learn how tax inputs work and to link tax inputs to other inputs for purposes of tax calculations.

### Investment/Capital Taxes

Investment gains or gains from the sale of an asset may be subject to taxes which are calculated separately from taxes on employment income. In this case, a tax input could be created called "Capital Gains Taxes" would be created to calculate these taxes.

This type of tax input would be linked to [investment account][account] and [asset][asset] inputs whose gains are taxable. 

### Progressive Income Taxes

The most advanced tax inputs include:

* A tax bracket with multiple tax rates for different levels of income.
* Links to one or more inputs as [tax sources][taxSource], such as incomes or account interest.
* Links to inputs serving as [itemized deductions][deduction], such as expenses or mortgage loan interest. 

As appropriate, multiple tax inputs could be used for different tax jurisdictions, such as the U.S. federal and state level.