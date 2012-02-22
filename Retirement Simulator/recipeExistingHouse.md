# Home Currently Owned

For a home which is currently owned, an [asset input][1] is used to represent the property ownership. 

If there is a mortgage loan outstanding, a  [loan input][2] would also be created. If the interest paid on this loan is tax deductible, the loan interest would be selected as a tax deduction for [tax inputs][5].

Separate from the loan input, [expense inputs][4] for property taxes or insurance payments are also needed. By keeping these expenses separate, they can also be itemized for tax deductions where applicable.

If the home was purchased at the same time the mortgage loan was originated, a [milestone date][3] could be created for the purchase date. Both the __Purchase Date__ for the asset input and the mortgage loan's __Origination Date__ could then reference this same milestone date.

## Related Examples

* [Vehicle Currently Owned](recipeExistingVehicle.html)

[1]:asset.html
[2]:loan.html
[3]:milestoneDate.html
[4]:expense.md
[5]:tax.md
