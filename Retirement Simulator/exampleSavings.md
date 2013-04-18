## Savings and Investment Examples

### Regular Savings

A "regular savings" account refers to an account where after tax income 
is deposited into an account, and the account accrues interest. An [account input][account] represents
a regular savings account.

The [current balance][currentBal], [withdrawal order][withdrawPriority], interest rate and contributions for this type
of are configured like any other account. 

What makes a regular savings account
unique is the interest earned is typically taxed as income. To 
specify the interest as taxable, the account would be selected in the [tax sources][taxSource]
of the appropriate [tax input][tax]; equivalently, the account can be 
selected as having taxable interest in the __Taxes__ section of the account itself.

If the return rate is currently low, but expected to rise over time,
a [variable return][varReturn] rate can also be used with a savings account.

### 401K Investment Account

A 401K account is an account where tax deductible contributions
are made into the account, the interest (or investment returns) accrue
tax free, but withdrawals are taxable. An [account input][account] represents
a 401K account.

The [current balance][currentBal], interest rate and contributions for this type
of are configured like any other account. 

To setup contributions as tax deductible, the account 
would be selected in the [tax deductions][deduction]
of the appropriate [tax input][tax]; equivalently, the account can be 
selected as having tax deductible contributions in the __Taxes__ section of the account itself.
Similarly, to specify the withdrawals as taxable, the account would be selected in the 
[tax sources][taxSource] of the appropriate tax input, or in the __Taxes__ section of the account itself.

Using the __Defer Withdrawals__ setting in the [account input][account], 401K accounts can 
also be configured with deferred withdrawals. A [milestone date][milestone] 
can also be setup for the deferred withdrawal date; such a milestone date
could be shared by other accounts, such as Roth IRAs or other 401Ks.

### Roth IRA Account

A Roth IRA account is an account where after tax contributions
are made into the account, the interest (or investment returns) accrue
tax free, and withdrawals are tax free. An [account input][account]
Roth IRA account.

The [current balance][currentBal], interest rate and contributions for this type
of are configured like any other account. 

What makes a Roth IRA account
unique is contributions are made with after tax income, but
withdrawals are tax free. Assuming [income inputs][income], such as employment income, 
are already setup
as [tax sources][taxSource] for appropriate [tax inputs][tax], contributions
to the Roth IRA will occur with after-tax income. Since withdrawals
are tax free, there is nothing else to setup with respect to taxes.

Using the __Defer Withdrawals__ setting in the [account input][account], Roth IRA 
accounts can also be configured with deferred withdrawals. A [milestone date][milestone] 
can also be setup for the deferred withdrawal date; such a milestone date
could be shared by other accounts, such as 401Ks] or other Roth IRAs.

### Brokerage Account

