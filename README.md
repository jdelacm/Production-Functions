# Production-Functions

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
Assuming perfect competition and constant returns to scale then the elasticities equal the share of revenues paid to each input (see De Locker et al, 2020 and Syverson 2011). This is a good first approach to identify the production function. In our dataset you can use expenditure variables to get capital and labor elasticities. Capital expenditure: kexp, Staff expense: xlr, Cost of goods sold: cogs.

### **TFP**
Once we have estimates for the input elasticities we can construct TFP measures as the ratio of output to input contributions. The input contribution is an index that consists of properly weighted individual inputs. In case of Cobb-Douglas production function this is just weighted geometric mean of inputs, with output elasticities as weights (See Syverson 2011, Section 2.2).


## Contents

- **`Create_Data.do`**  
  Stata script for cleaning, merging, and processing firm-level and macroeconomic data.  
  This code is taken directly from the replication files of De Loecker et al. (2020).  
  Refer to the comments and documentation within the script to understand the variables and transformations.

  **Key steps performed in this script:**

     **Load firm-level data** from Compustat (e.g. `all_90_25_tic.dta`)
     **Clean and filter observations:**
     - Remove duplicate entries by firm-year
     - Drop firms without industry classification (NAICS)
     - Retain only consolidated firm records
     **Construct industry identifiers**:
     - Generate 2-, 3-, and 4-digit NAICS codes
     - Group firms accordingly
    **Adjust monetary variables**:
     - Reconstruct missing market values using share price × shares outstanding
     - Scale all monetary variables to consistent units (×1000)
    **Merge macroeconomic data**:
     - Merge GDP deflator and user cost of capital by year
     - Compute deflated versions of firm-level variables
    **Generate derived variables**:
     - Capital expenditure (`kexp`)
     - Imputed materials cost (`mat1`)
     - Sales-to-COGS ratio (`s_g`)
    **Trim outliers**:
     - Remove extreme `s_g` values (bottom/top percentiles)
     - Save datasets for different trimming thresholds (1%, 2%, ..., 5%)
    **Export datasets**:
     - Save final `.dta` files
     - Export trimmed dataset as `data.csv`

- **data**
  Folder with required data and storage of data from Create_Data.do.
  - **Macroeconomic Data**
    - Nominal interest rates (FRED)
    - U.S. GDP deflator
    - User cost of capital computed using nominal rates, inflation, and depreciation.

## Citation

De Loecker, Jan, Jan Eeckhout, and Gabriel Unger.  
*"The Rise of Market Power and the Macroeconomic Implications."*  
Quarterly Journal of Economics, 2020.
