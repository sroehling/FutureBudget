## Loan Input

A loan input represents money borrowed. For example, a loan input would be created to represent money borrowed to pay for a [house][exampleHomeOwnership] or [car][exampleCarOwnership].

### Outstanding Loan Balance

A [loan][loan]'s outstanding balance provides a current "snapshot" of the loan balance as 
of the [start date][resultsTimeFrame] for the calculation of results. 

If the [origination date][loanOrig] of the loan 
is before the [results start date][resultsTimeFrame], the outstanding loan balance represents
the balance as of this start date. The assumption is this starting balance could 
include any extra payments which have already been payed on the loan's principal balance.

However, if the origination date is 
after the simulation start date (e.g., for an loan you plan to take in the future), 
an outstanding balance is not needed.

### Loan Origination

Loan origination parameters include the following:

* __Origination Date__ - When the loan was originated or is expected to originate. For existing loans, enter a date in the past. A future date is used for loans expected to originate in the future.
* __Amount Borrowed__ - If the loan originated in the past, enter the actual amount borrowed. If the __Origination Date__ is in the future, the amount borrowed will typically be entered as a current value, and the __Amount Borrowed Growth Rate__ is used to adjust the amount borrowed for inflation.
* __Amount Borrowed Growth Rate__ - This setting is only for loans which have an __Origination Date__ in the future. This growth rate adjusts for inflation the amount borrowed until the future origination date.
* __Interest Rate__ - Yearly interest rate charged for the loan.
* __Duration__ - Starting with the __Origination Date__, how long it will take to payoff the loan (notwithstanding extra payments or an early payoff).

### Interest Rate

A loan's interest rate is the yearly interest rate used to calculate the monthly periodic payment and interest. A fixed value can be used for loans with a fixed rate, or a [variable interest rate][variableInterest] can be used for loans or adjustable rate mortages (ARMs), whose rate may adjust over time.

### Deferred Payments

By default, deferred payments are disabled, meaning regular payments (principle and interest) start one month after the origination date. With deferred payments, regular payments are delayed until the deferall date (deferred payment date). 

Deferred payments can be used for student loans, where payments don't start until after graduation. Similarly, deferred payments can be used for interest only loans, where regular payments are deferred indefinitely, but an interest-only payment is made each month.

If payments are deferred, there is an option to pay interest while regular payments are deferred. If interest is not paid while regular payments are deferred, then any upaid interest will be added to the principal balance, and the regular payment amount will increase when regular payments start. 

There is a second option for subsidized interest. If the interest is subsidized, the assumption is money to pay the interest will not be withdrawn from your cash or account balances. This option is intended to represent subsidized student loans, where the government pays the interest while a loan is in deferrment.  