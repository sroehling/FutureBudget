## Asset Input

An asset input represents property owned, such as a [house][exampleHomeOwnership] or [car][exampleCarOwnership].

### Current Asset Value

An [asset][asset]'s current value provides a "snapshot" of the asset as of the
[start date][resultsTimeFrame] for calculating forecast results. If the purchase date of the asset is before the [start date][resultsTimeFrame], 
the current value provides an estimate of the asset's value as of this start date. If a current value is not provided, the asset value
as of the start date will be estimated as the original purchase price along with any appreciation or depreciation (see below) between the purchase date and start date.

However, if the purchase date is after the start date 
(e.g., for an house or car you plan to purchase in the future), a current value is not needed.

### Appreciation and Depreciation

Many types of assets appreciate (increase) in value and price until the purchase is made, then depreciate thereafter. For example, the purchase price for a new automobile will typically increase (or at least remain stable) until the purchase is made. However, after the purchase, the automobile's value will immediately begin depreciating. To support assets which typically appreciate before a purchase, but depreciate thereafter, asset inputs have a appreciation/depreciation value for both before and after the purchase. Positive values represent yearly appreciation, while negative values represent depreciation.

To represent assets which continue to appreciate after being purchased, the same appreciation/depreciation value can be used for before and after the purchase. For example, a home may be expected to appreciate both before and after its purchase.
