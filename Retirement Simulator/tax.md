## Tax Input

A tax input includes a tax bracket which determines the [tax rate(s)][taxRate] associated with linked inputs. When the tax input is first created, there are a number of presets for creating example tax brackets. Different tax brackets offer flexibility to represent different types of investment capital gains, progressive income, effective tax rates, or flat income taxes.

Once a tax input has been created with an associated tax bracket, the way tax inputs basically work are to link with other inputs to calculate the taxes to be paid. In particular, a tax input can be linked with [income][income],[account][account] and [asset][asset] inputs to calculate the taxes paid on income, account returns or withdrawals, and asset gains respectively. A tax input can also be linked with [expense][expense] or [account][account] inputs to calculate deductions, credits, or adjustments for certain expenses, account contributions, or withdrawals.

The [tax examples][taxesExample] also provide some suggestions for creating different types of tax inputs.

### Tax Rates

A tax input's tax rates are the percentages of taxes paid for the income amounts
associated with input's [tax sources][taxSource]. 

A tax bracket with a single entry and a cutoff amount of $0 will result in the same percentage
being used for all amounts. This type of tax bracket can be used to
represent a "flat tax" or an effective tax rate.  

A tax bracket with multiple entries allows different percentages to be used for different amounts.
For example, a progressive income tax includes higher tax percentage for larger taxable incomes.

When creating tax inputs, some presets are provided with different examples of tax brackets.

### Tax Sources

To specify where the taxes come from, a tax input needs to be linked with other inputs.
The amounts subject to taxes can include incomes, savings interest, 
asset sales, taxable withdrawals, or investment gains.

Along with the tax input's [tax rate][taxRate] and any [deductions][deduction], [credits][credit],
or [adjustments][adjustment], the sum total of amounts from all tax sources
is used in the calculation of the taxes paid.

### Adjustments

Specify adjustments to the total taxable amount (gross income), including 
eligible expenses, account contributions, or loan interest. The result 
after subtracting these adjustment is typically called an 
adjusted gross income (AGI).

### Deductions

Specify a standard deduction and/or itemized deductions, of which the greater of 
the two is subtracted from the adjusted gross income. Itemized deductions 
include eligible expenses, account interest, and loan interest.

### Exemptions

In addition to specific adjustments, eligible exemptions 
(such as for children) further reduce the tax liability.

### Credits

Itemize credits to reduce the taxable amount, after adjustments, 
deductions, and exemptions have already been applied.
