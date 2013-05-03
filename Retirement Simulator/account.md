## Account Input

Account inputs represent various types of savings and investment accounts,
such as [regular savings][exampleRegularSavings], [401Ks][example401K], or [Roth IRAs][exampleRoth].

All account inputs have a __Current Balance__, 
__Investment/Return Rate__. Accounts also have a __Withdrawal Priority__, which 
determines an account's relative order for withdrawals. Regular 
contributions can also be set up for any account, including a 
__Contribution Amount__ and repeat frequency.

Account inputs are different in the way withdrawals are limited, contributions are taxed, 
withdrawals are taxed, or interest (returns) are [taxed][tax]. For example, the interest on [regular savings][exampleRegularSavings]
taxed as income, the contributions to a [401Ks][example401K] are tax deductable, but withdrawals from a [Roth IRA][exampleRoth]
are not taxed.

### Dividends

TBD

### Current Account Balances

For each account, a current balance needs to be provided. This current balance provides a "snapshot" of the account as of the [start date][resultsTimeFrame] for calculating results.

### Withdrawal Order

Relative to (versus) other accounts, an account's withdrawal order determines the order in which money will be withdrawn from accounts to pay expenses. 

Accounts with a lower order (listed higher in the list) will be withdrawn from before 
accounts with a higher order (listed lower in the list).

For example, an escrow account for [irregular expenses][expenseExampleIrregular] may be ordered higher than a long term or emergency savings account.

### Limited Withdrawals

Select one or more expenses which are eligible for withdrawal 
from this account. Or, leave all the expenses unselected to
allow any expense to be funded using a withdrawal from this account
