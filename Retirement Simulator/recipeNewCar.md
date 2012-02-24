# Purchase a New Vehicle

A vehicle such as a car or boat is represented as an 
[asset input][2]. If the plan is to take loan for the vehicle, a second
[loan input][3] is also required.

## Instructions

1. Create an [asset input][2] to represent the vehicle's value and depreciation.

	* Set the __Purchase Date__ to the date you plan to purchase the vehicle.
	
	* Set the __Purchase Cost__ to the price, in today's terms, you expect to pay for the vehicle.

2. If the plan is to take out a loan for the vehicle, create an associated [loan input][3]. 

	* Set the __Amount Borrowed__, __Origination Date__, __Interest Rate__ 
	  and __Duration__ to the 
	  expected terms of the loan. A payment will be calculated from these values. 
	  
	
	* Set the  __Amount Borrowed Growth Rate__ to the price inflation expected leading up
	  to the purchase of the vehicle.

	* Set the __Origination Date__ to the date you plan to purchase the vehicle. 
		To ensure this date matches the __Purchase Date__ described above, a 
	  [milestone date][1] can also be created and shared between the asset and loan inputs.

## Related Examples

* [Vehicle Currently Owned](recipeExistingVehicle.html) 
* [Home Currently Owned](recipeExistingHouse.html)

[1]:milestoneDate.html
[2]:asset.html
[3]:loan.html