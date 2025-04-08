cd "/Users/jcm/Desktop/Theses Bachelor UVA/Compustat data, Production Functions and TFP/data"

* === Step 1: Import Nominal Interest Rate (Federal Funds Rate) ===
import delimited "RIFSPFFNA.csv", clear
rename rifspffna interest
gen year = year(date(observation_date, "YMD"))
collapse (mean) interest, by(year)
tempfile interest_data
save `interest_data'

* === Step 2: Import Inflation Rate (CPI YoY) ===
import delimited "FPCPITOTLZGUSA.csv", clear
rename fpcpitotlzgusa inflation
gen year = year(date(observation_date, "YMD"))
collapse (mean) inflation, by(year)
tempfile inflation_data
save `inflation_data'

* === Step 3: Merge Interest + Inflation, and Calculate User Cost ===
use `interest_data', clear
merge 1:1 year using `inflation_data', keep(match) nogenerate

* Convert to decimals
gen i = interest / 100
gen pi = inflation / 100

* Drop percentage variables
drop interest
drop inflation

* Depreciation (12%)
scalar delta = 0.12

* User cost: i - pi + delta
gen usercost = i - pi + delta

tempfile usercost_data
save `usercost_data'

* === Step 4: Import Real GDP and Normalize to 2009 = 100 ===
import delimited "A191RD3A086NBEA.csv", clear
rename a191rd3a086nbea USGDP17
gen year = year(date(observation_date, "YMD"))
drop observation_date

* Normalize to 2009 = 100
summarize USGDP17 if year == 2009
scalar base_2009 = r(mean)
gen USGDP = (USGDP17 / base_2009) * 100
drop USGDP17

* === Step 5: Merge GDP with User Cost and Save ===
merge 1:1 year using `usercost_data', keep(match) nogenerate

save "macro_vars.dta", replace
