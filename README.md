# Production Function Estimation

This repository contains relevant materials, code, and resources for research on **Production Function Estimation**.

## Compustat data, Production Functions and TFP

### **Firm-Level Data (Compustat North America)**
Accessed via WRDS (through UvA library):
- **Dataset:** Fundamentals Annual
- **Date Range:** 1955–2025
- **Selection Criteria:**
  - Consolidated accounts
  - Format: INDL and FS (drop FS if both reported)
  - Domestic population only
- **Variables Used:**  
  `SALE, COGS, XLR, XSGA, PPEGT, PPENT, INTAN, XRD, XAD, EMP, MKVALT, DVT, NAICS, GVKEY, TIC, CSHO, OIBDP, PRCC_F`


### **Output elasticities**
Using financial statement data, we estimate **output elasticities** of capital and labor. Several estimators are implemented:
- **Olley-Pakes (OP)**
- **Levinsohn-Petrin (LP)**
- **Ackerberg-Caves-Frazer (ACF)**
- **Wooldridge (WRDG)**

Assuming perfect competition and constant returns to scale, the elasticities are equivalent to revenue shares of inputs (see De Loecker et al., 2020; Syverson, 2011). This provides a useful baseline for production function identification.

### **TFP**
TFP is computed as the ratio of actual output to the predicted contribution of inputs. In a Cobb-Douglas specification, this simplifies to a weighted geometric mean of inputs:

\[
TFP_{it} = \frac{Y_{it}}{K_{it}^{\alpha_K} L_{it}^{\alpha_L}
\]

where weights \(\alpha\) are estimated output elasticities. For further details, see Syverson (2011), Section 2.2.


## Contents

### `Create_Data.do`

Stata script for cleaning, processing, and merging firm-level and macroeconomic data. This file is adapted from the replication materials of De Loecker et al. (2020).

**Main steps:**
- Load Compustat data
- Remove duplicates, drop firms without NAICS, and keep only consolidated records
- Generate 2-, 3-, and 4-digit NAICS codes
- Adjust monetary variables (e.g. reconstruct market value as `PRCC_F * CSHO`)
- Merge macro data (GDP deflator, interest rates, user cost of capital)
- Generate derived variables (e.g. capital expenditures, imputed materials)
- Trim outliers based on the sales-to-COGS ratio
- Save cleaned datasets (`.dta` and `.csv`)

---

### `Prod_Fun_Est.do`

Stata script for estimating production functions using `prodest`.

**Key features:**
- Filters the sample by year range and NAICS industry (2-, 3-, or 4-digit)
- Constructs log-transformed variables:
  - `y`: Output (log of sales)
  - `k`: Capital
  - `l`: Labor (number of employees)
  - `m`: Intermediate inputs (COGS minus labor expenses)
- Estimates three specifications:
  1. **OLS Cobb-Douglas**
  2. **Levinsohn-Petrin (LP)** using `method(lp)`
  3. **ACF correction** using `method(lp) acf`
- Saves first-stage residuals for TFP construction
- Outputs results using `esttab` (LaTeX-compatible)




## References

De Loecker, Jan, Jan Eeckhout, and Gabriel Unger.  
*"The Rise of Market Power and the Macroeconomic Implications."*  
*Quarterly Journal of Economics*, 2020.

Olley, G. Steven, and Ariel Pakes.  
*"The Dynamics of Productivity in the Telecommunications Equipment Industry."*  
*Econometrica*, 1996, Vol. 64(6), pp. 1263–1297.

Levinsohn, James, and Amil Petrin.  
*"Estimating Production Functions Using Inputs to Control for Unobservables."*  
*Review of Economic Studies*, 2003, Vol. 70(2), pp. 317–341.

Ackerberg, Daniel A., Kevin Caves, and Garth Frazer.  
*"Identification Properties of Recent Production Function Estimators."*  
*Econometrica*, 2015, Vol. 83(6), pp. 2411–2451.

Wooldridge, Jeffrey M.  
*"On Estimating Firm-Level Production Functions Using Proxy Variables to Control for Unobservables."*  
*Economics Letters*, 2009, Vol. 104(3), pp. 112–114.

Syverson, Chad.  
*"What Determines Productivity?"*  
*Journal of Economic Literature*, 2011, Vol. 49(2), pp. 326–365.
