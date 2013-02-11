# Outstanding Loan Balances

A [loan][loan]'s outstanding balance provides a current "snapshot" of the loan balance as 
of the [start date][simTimeFrame] of the simulation. 

If the [origination date][loanOrig] of the loan 
is before the [simulation start date][1], the outstanding loan balance represents
the balance as of this start date. The assumption is this starting balance could 
include any extra payments which have already been payed on the loan's principal balance.

However, if the origination date is 
after the simulation start date (e.g., for an loan you plan to take in the future), 
an outstanding balance is not needed.

## See Also

* [Simulation Time Frame][simTimeFrame]
* [Loan Origination][loanOrig]
* [Loan Input][loan]

[simTimeFrame]:simTimeFrame.html
[loan]:loan.html
[loanOrig]:loanOrig.html