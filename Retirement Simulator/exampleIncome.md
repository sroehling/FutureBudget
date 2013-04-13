## Income Examples

### Employment Income

As an employee, the paycheck you receive already has payments for taxes, insurance and other benefits withheld. In other words, "take home pay" is the amount on the check after all these withholdings.

When first starting to use the app, a suggested way to represent employment income is add a simple [income input][income] called "Take Home Pay" (or similar).

However, when and if you expect to perform what-if analyses with employment income or represent [taxes][taxesExample] in more detail, employment income can be split into multiple inputs; for example:

* An [income input][income] called "Gross Income" to represent your overall salary.
* One or more [tax inputs][tax] for the different types of taxes deducted from the income. These tax inputs would be linked to the "Gross Income" input to pay the appropriate taxes.
* One or more [expense inputs][expense] for the payments of insurance and other benefits deducted from your paycheck. 

### Contractor Income

In contrast to employment income, when working as an independent contractor, the payments you receive typically do not deduct payments for taxes or employment benefits. It is the responsibility of the contractor to pay taxes, purchase insurance, etc. 

Contractor income would be split into multiple inputs much the same as employment income (see above). In particular, you would have a [income input][income] called "Gross Contractor Income", and one more [tax][tax] and [expense][expense] inputs for tax and benefit payments.

### Pay Raises

The __Amount__ and __Yearly Increase__ fields for an [income input][income] together represent the income's amount over time. The __Yearly Increase__ is by default the same as the default inflation rate, so in terms of income this by default only represents a "cost of living" increase. 

To represent a pay increase other than a normal cost of living increase (e.g., for a promotion), a [variable amount][variableAmount] would be used for an income's __Amount__, where the starting amount is the income before the pay raise, and the change in amount occurs on the date of the expected pay raise with a value of the increased income (e.g., 5-10% more than the starting amount).

Another way to represent pay increases is to use a [variable growth rate][variableInflation] for the __Yearly Increase__ field. This fields value could have a starting value which is the same as the default inflation rate, increase for periods you expect income growth, then decrease for periods you're expecting income to plateau. 

### Going Part-Time

If you expect to work part-time when your children are young or semi-retire, this can be represented much the same was as pay raise example described above. In this case, a [variable amount][variableAmount] would also be used for an income's __Amount__. This variable amount would start with the full-time income amount, then change to a reduced amount for periods of expected part-time income.

### Windfall Income

In your lifetime, you may experience a one time income from the sale of a business, legal settlement, inheritance, or similar. If you expect such an event may take place, it can be represented as an [income input][income] whose __Start Date__ field is set to the date of the possible income, and the __Repeat__ field is set to "Once".

When income is received, it is by default added to the cash balance. So, if the intent is to re-invest this income, a second [transfer input][transfer] would be created to move the money into the appropriate account. Assuming the __Start Date__ for the transfer and income are the same a [milestone date][milestone] could be created for the expected windfall income date, then the __Start Date__ for both the income and transfer could be set to this same date.
