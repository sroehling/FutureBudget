## Housing Examples

### Home Ownership

A home mortgage is often times setup so you pay a single amount each month. The mortgage company not only pays down the loan, but also pays property taxes and insurance from an escrow account. 

When first starting to use the app, one way to represent home ownership is add a simple [expense input][expense] called "Mortgage Payment" (or similar). However, when and if you expect to perform what-if analyses with loan parameters (e.g., make extra payments on the loan) or pay off the loan, home ownership should be broken down into multiple inputs; for example:

* An [asset input][asset] to represent the property ownership. 
* A  [loan input][loan] for the money borrowed to purchase the home. If the interest paid on this loan is tax deductible, the loan interest could also be selected as a [tax deduction][tax] for [tax inputs][tax].
* [Expense inputs][expense] for property taxes, insurance payments, HOA dues, etc. By keeping property taxes separate, they can also be itemized for [tax deductions][deduction] where applicable.

After splitting housing into multiple inputs, a suggestion is to [tag][tags] all the housing related inputs with a tag named "Housing" or similar. Then, if you want to focus on housing related inputs, the input list can be filtered accordingly.

Assuming the home was or will be purchased at the same time the mortgage loan is originated, a [milestone date][milestone] can be created for the purchase date. The __Purchase Date__ for the [asset input][asset], the mortgage loan's __Origination Date__, and the __Start Date__ for related expenses could then reference this same milestone date.

### Renting

When renting, you typically make a single monthly payment to the property owner, who then pays the mortgage, property taxes and other expenses. So, if you're renting, or planning to rent, you can typically setup a single monthly expense called "Rent Payment". 

One interesting renting [scenario][scenario] would be taking on an extra roommate. The payment amount would be reduced to your portion of the overall rent. Other monthly expenses, such as utilities would also be reduced.

### Paying Off a House

If you expect to pay off a house, you would first need create separate asset, loan and expense inputs to represent [home ownership][exampleHomeOwnership]. In particular, the home loan needs to be separate from the other home ownership related inputs; the reason is once the house is paid off, certain expenses will continue and the home can still be considered an asset.

Depending upon how quickly you want to pay off the house, the [loan input][loan] representing the home loan can be setup accordingly. The loan input can be setup with extra payments, an early payoff date, or both.

Once the home is paid off, and assuming there are no expected changes to income or other expenses, you will want to consider what to do with all the money not being spent on payments for the home loan. One option is to create a [transfer input][transfer] to move the excess money from cash to an investment or savigs account.
