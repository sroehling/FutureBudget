# 401K Investment Account

A 401K account is an account where tax deductable contributions
are made into the account, the interest (or investment returns) accrue
tax free, but withdrawals are taxable. A [account input][1] represents
a 401K account.

The [current balance][2], interest rate and contributions for this type
of are configured like any other account. 

To setup contributions as tax deductable, the account 
would be selected in the [tax deductions][3]
of the appropriate [tax input][4]; equivalently, the account can be 
selected as having tax deductable contributions in the __Taxes__ section of the account itself.
Similarly, to specify the withdrawals as taxable, the account would be selected in the 
[tax sources][7] of the appropriate tax input, or in the __Taxes__ section of the account itself.

Using the __Defer Withdrawals__ setting in the [account input][1], 401K accounts can 
also be configured with deferred withdrawals. A [milestone date][5] 
can also be setup for the deferred withdrawal date; such a milestone date
could be shared by other accounts, such as [Roth IRAs][6] or other 401Ks.

While deferred withdrawals determine when withdrawals can occur from an account,
the [withdrawal priority][8] setting determines the relative order in which withdrawals
will occur amongst different accounts.

## See Also

* [Account Input][1]
* [Current Balances][2]
* [Tax Sources][7]
* [Tax Input][4]

[1]:account.html
[2]:currentBalances.html
[3]:taxDeductions.html
[4]:tax.html
[5]:milestoneDate.html
[6]:recipeInvestmentRothIRA.html
[7]:taxSource.html
[8]:accountWithdrawalPriority.html