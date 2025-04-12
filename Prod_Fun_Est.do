*******************************************************
* Production Function Estimation: OLS, LP, and ACF
* Filters: Years, NAICS (2–4 digit), using levpet & acfest
*******************************************************

* Set working directory
cd "/Users/jcm/Desktop/Theses Bachelor UVA/Compustat data, Production Functions and TFP/data"

* Install required packages (only runs if not installed)
ssc install prodest, replace
ssc install estout, replace

* Load data
use data.dta, clear

*==============================*
* 0. Filter data (year + NAICS)
*==============================*

* Define year range
local year_min = 2000
local year_max = 2020
keep if year >= `year_min' & year <= `year_max'

* Define NAICS code (2-, 3-, or 4-digit)
local naics_code = 331   // change to 33, 336, etc.

* Apply NAICS filter
local code_length = strlen("`naics_code'")
if `code_length' == 2 {
    keep if ind2d == `naics_code'
}
else if `code_length' == 3 {
    keep if ind3d == `naics_code'
}
else if `code_length' == 4 {
    keep if ind4d == `naics_code'
}
else {
    di as error "Invalid NAICS code length: `naics_code'"
    exit 1
}

*==============================*
* 1. Prepare variables
*==============================*

* Create firm ID
egen id = group(gvkey)

* Drop invalid or missing values
drop if missing(sale_D, cogs_D, xlr_D, emp, capital_D)
drop if sale_D <= 0 | cogs_D <= 0 | emp <= 0 | capital_D <= 0

* Construct log variables
gen y = ln(sale_D)
gen m = ln(cogs_D - xlr_D)
gen l = ln(emp)
gen k = ln(capital_D)

* Optional: drop if m is missing due to subtraction
drop if missing(m)

* Declare panel
xtset id year

*==============================*
* 2. OLS Cobb-Douglas
*==============================*
reg y k l, robust
est store ols

*==============================*
* 3. Levinsohn-Petrin (LP)
*==============================*
prodest y, method(lp) free(l) proxy(m) state(k) id(id) t(year) poly(3) fsresiduals(lp_resid)
est store lp

*==============================*
* 4. ACF (LP + ACF correction)
*==============================*
prodest y, method(lp) acf free(l) proxy(m) state(k) id(id) t(year) poly(3) fsresiduals(acf_resid)
est store acf

*==============================*
* 5. Compare Estimates
*==============================*
esttab ols lp acf using "estimates_production.tex", replace se b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
title(Production Function Estimation: NAICS `naics_code', Years `year_min'-`year_max') label

esttab ols lp acf, se b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
title(Production Function Estimation: NAICS `naics_code', Years `year_min'-`year_max') label
