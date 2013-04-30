## Transportation Examples

### Purchasing a Vehicle

A vehicle you own, or plan to own, is represented as an [asset input][asset]. If you borrowed money (or plan to borrow money) to pay for the vehicle, a [loan input][loan] is also required.

Instructions:

1. Create an [asset input][asset] to represent the vehicle's value and depreciation.
  * Set the __Purchase Date__ to the date you acquired the vehicle.	
  * Set the __Purchase Cost__ to the price originally paid for the vehicle.	
  * Set the __Current Value__ to an estimate of the vehicle's current "used vehicle" value. This value is used as a starting value and represents depreciation which has already occurred.

2. If there is an outstanding auto loan on the vehicle, create an associated [loan input][loan]. 
  * Set the __Amount Borrowed__, __Origination Date__, __Interest Rate__  and __Duration__ to the original terms of the loan. A payment will be calculated from these values. If the loan originated in the past, there is no need to provide an __Amount Borrowed Growth Rate__.
  * Set the __Origination Date__ to the date you acquired the vehicle. If you want to ensure this date matches the __Purchase Date__ described above, a [milestone date][milestone] can also be created and shared between the asset and loan inputs. 
  * Set the __Outstanding Balance__ to the amount still owed on the loan. Similar to an asset input's __Current Value__, this outstanding balance is used as a starting point in the simulation.

### Leasing a Vehicle

When leasing a vehicle, a monthly payment is made for the term or number of months in the lease. Although this payment may be less than the loan payment to purchase the same vehicle, the vehicle is not owned at the end of the lease. If you're leasing, or planning to lease a vehicle, you can typically setup a single monthly expense called "Lease Payment".
