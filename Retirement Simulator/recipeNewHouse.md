# Purchase a New Home

For a planned home purchase, an [asset input][1] is used to represent the property ownership. 

If there is a mortgage loan outstanding, a  [loan input][2] would also be created. If the interest paid on this loan is tax deductible, the loan interest would be selected as a [tax deduction][8] for [tax inputs][5].

Separate from the loan input, [expense inputs][4] for property taxes or insurance payments are also needed. By keeping these expenses separate, they can also be itemized for [tax deductions][8] where applicable.

Assuming the home will be purchased at the same time the mortgage loan is originated, a [milestone date][3] can be created for the purchase date. The __Purchase Date__ for the [asset input][1], the mortgage loan's __Origination Date__, and the __Start Date__ for related expenses could then reference this same milestone date.

## Related Examples

* [Purchase a New Home][7]
* [Vehicle Currently Owned][6]

[1]:asset.html
[2]:loan.html
[3]:milestoneDate.html
[4]:expense.html
[5]:tax.html
[6]:recipeExistingVehicle.html
[7]:recipeNewHouse.html
[8]:taxDeductions.html