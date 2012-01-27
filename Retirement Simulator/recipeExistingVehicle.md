## Vehicle Currently Owned

A vehicle such as a car or boat which you already own is represented as an 
asset input. If there is also an outstanding loan on the vehicle, a second
loan input is also required.

### Instructions

1. Create an asset input to represent the vehicle's value and depreciation.

	* Set the __Purchase Date__ to the date you acquired the vehicle.
	
	* Set the __Purchase Cost__ to the price originally paid for the vehicle.
	
	* Set the __Current Value__ to an estimate of the vehicle's current "used vehicle" value. 
	  This value is used as a starting value in the simulation and represents depreciation 
	  which has already occured.

2. If there is an outstanding auto loan on the vehicle, create an associated loan input. 

	* Set the __Amount Borrowed__, __Origination Date__, __Interest Rate__ 
	  and __Duration__ to the 
	  original terms of the loan. A payment will be calculated from these values. 
	  Since the loan originated in the past, there is no need to provide a 
	  __Amount Borrowed Growth Rate__.

	* Set the __Origination Date__ to the date you acquired the vehicle. If you want
	  to ensure this date matches the __Purchase Date__ described above, a 
	  [milestone date][1] can also be created and shared between the asset and loan inputs. 

	* Set the __Outstanding Balance__ to the amount still owed on the loan. Similar to 
	  an asset input's __Current Value__, this outstanding balance is used as a starting 
	  point in the simulation. 

### Related Recipes

* [Purchase a New Car](recipeNewCar.html) 
* [Home Currently Owned](recipeExistingHouse.html)

[1]:milestoneDate.html