# Regular Savings

A "regular savings" account refers to an account where after tax income 
is deposited into an account, and the account accrues interest. An [account input][1] represents
a regular savings account.

The [current balance][2], [withdrawal priority][4], interest rate and contributions for this type
of are configured like any other account. 

What makes a regular savings account
unique is the interest earned is typically taxed as income. To 
specify the interest as taxable, the account would be selected in the [tax sources][3]
of the appropriate [tax input][5]; equivalently, the account can be 
selected as having taxable interest in the __Taxes__ section of the account itself.

While deferred withdrawals determine when withdrawals can occur from an account,
the [withdrawal priority][4] setting determines the relative order in which withdrawals
will occur amongst different accounts.

If the return rate is currently low, but expected to rise over time,
a [variable return][6] rate can also be used with a savings account.

## See Also

* [Account Input][1]
* [Current Balances][2]
* [Tax Sources][3]
* [Account Withdrawal Priority][4]

[1]:account.html
[2]:currentBalances.html
[3]:taxSource.html
[4]:accountWithdrawalPriority.html
[5]:tax.html
[6]:variableReturn.html