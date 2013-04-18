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
