# NSS 77th Round Analysis: Agricultural Households in India

## Project Overview

This project analyzes data from the National Sample Survey (NSS) 77th Round (2019) focusing on agricultural households in India. The analysis examines determinants of household welfare using both basic and enhanced econometric techniques, with particular emphasis on land ownership, education, social factors, and access to technical advice.

## Research Objectives

- Identify key determinants of household consumption expenditure (MPCE) among agricultural households
- Analyze the relationship between land ownership patterns and economic welfare
- Examine the impact of education, social groups, and technical advice on household economic status
- Conduct advanced diagnostic tests and robustness checks using enhanced analytical methods
- Provide policy-relevant insights for agricultural development programs


## Technical Implementation

### Data Sources
- **NSS 77th Round** (2019): Land and Livestock Survey
- **Multiple survey modules**: Demographics, Land Ownership, Technical Advice, Weights
- **Sample**: 20,180 agricultural households across India

### Key Variables

| Variable | Description | Type |
|----------|-------------|------|
| `mpce_per_capita` | Monthly Per Capita Expenditure (Rupees) | Continuous |
| `log_mpce` | Log-transformed MPCE | Continuous |
| `total_land` | Total land owned (acres) | Continuous |
| `land_size_cat` | Land size categories | Categorical |
| `educ_level` | Education level of household head | Categorical |
| `social_group_f` | Social group (ST, SC, OBC, Others) | Categorical |
| `tech_advice_f` | Received technical advice (Yes/No) | Binary |
| `hh_size` | Household size | Continuous |
| `age_head` | Age of household head | Continuous |
| `gender_f` | Gender of household head | Categorical |

### Methodology

#### Basic Analysis
1. **Data Integration**: Merged multiple survey modules using household identifiers
2. **Variable Transformation**: Created meaningful categories and log transformations
3. **Regression Analysis**: 
   - OLS models with three specifications
   - Survey-weighted models accounting for complex survey design
4. **Visualization**: Comparative boxplots for key relationships

#### Enhanced Analysis
1. **Model Diagnostics**: Variance Inflation Factors (VIF), Breusch-Pagan test, Shapiro-Wilk test, Cook's Distance
2. **Robust Inference**: HC3 heteroskedasticity-consistent standard errors
3. **Advanced Methods**: Quantile regression, interaction effects, subgroup analysis
4. **Sensitivity Analysis**: Alternative specifications and outlier exclusion
5. **Enhanced Visualization**: Coefficient plots with confidence intervals, smoothed relationships

## 📈 Key Findings

### Basic Regression Results Summary

#### Model 1: Basic Determinants
- **Education**: Strong positive effect (Graduate+ → +33% MPCE)
- **Land**: Negative coefficient (-0.001) - requires further investigation
- **Household Size**: Negative effect (-0.067) - economies of scale
- **Social Groups**: ST (lowest), SC (+3.8%), OBC (+9.3%), Others (+19.2%)

#### Model 2: Technical Advice
- Technical advice not statistically significant (p = 0.104)
- Minimal impact on model fit

#### Model 3: Comprehensive Model
- **Age**: Positive effect (+0.005 per year)
- **Gender**: No significant difference
- **R-squared**: 20.8% (improved from 18.4%)

### Enhanced Analysis Findings

#### Model Diagnostics
- **Moderate multicollinearity** detected (VIF > 5 for some variables)
- **Significant heteroskedasticity** present (Breusch-Pagan p < 0.001)
- **Non-normal residuals** (Shapiro-Wilk p < 0.001)
- **5.24% influential observations** (Cook's Distance > threshold)

#### Robust Standard Errors Results
- **Graduate education**: +36% MPCE (p < 0.001)
- **Technical advice**: -1.2% effect (p = 0.051) - borderline significant
- **Land ownership**: -0.1% per acre (p < 0.001)
- **Household size**: -6.9% per additional member (p < 0.001)
- **Standard errors increased** by 1-17% compared to OLS

#### Survey-Weighted Analysis
- Larger standard errors due to complex survey design
- Land coefficient becomes positive (though insignificant)
- Stronger social group effects observed

## Visualizations

### Basic Visualizations
1. **MPCE by Land Size**: Expenditure distribution across land ownership categories
2. **MPCE by Education**: Education gradient in economic welfare
3. **MPCE by Social Group**: Social disparities in consumption expenditure

### Enhanced Visualizations
1. **Enhanced Coefficient Plot**: Regression coefficients with 95% confidence intervals
2. **Enhanced MPCE by Education**: Detailed distribution analysis
3. **Land-MPCE Relationship by Social Group**: Smoothed relationships with confidence bands

## Policy Implications

1. **Education Investment**: Strong returns to education (36% higher MPCE for graduates) suggest need for continued investment in rural education
2. **Social Inclusion**: Persistent disparities call for targeted interventions for ST/SC households
3. **Technical Advice**: Current extension services show limited impact (-1.2%, borderline significant), may need redesign for greater effectiveness
4. **Land Reforms**: Complex land-welfare relationship (small negative effect) warrants further investigation into land quality and productivity
5. **Robustness Concerns**: Heteroskedasticity and influential observations suggest need for careful interpretation and potential model refinements

## How to Run the Analysis

### Prerequisites
```r
# Required R packages
install.packages(c("tidyverse", "haven", "survey", "lmtest", "sandwich", "car", "broom", "quantreg"))
```

## Data Requirements

    NSS 77th Round data files in specified directory structure

    Required variables as defined in configuration section

## Sample Characteristics

    Total households: 20,180

    Land ownership: 19,696 households own land

    Technical advice: Coverage data for 18,773 households

    Geographic coverage: Nationally representative sample

## Enhanced Analysis Contributions

The enhanced analysis provides:

    Diagnostic validation of model assumptions

    Robust inference through heteroskedasticity-consistent standard errors

    Distributional insights through quantile regression

    Robustness checks through sensitivity analysis

