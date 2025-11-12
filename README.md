# NSS 77th Round Analysis: Agricultural Households in India

## Project Overview

This project analyzes data from the National Sample Survey (NSS) 77th Round (2019) focusing on agricultural households in India. The analysis examines determinants of household welfare, with particular emphasis on land ownership, education, social factors, and access to technical advice.

## Research Objectives

- Identify key determinants of household consumption expenditure (MPCE) among agricultural households
- Analyze the relationship between land ownership patterns and economic welfare
- Examine the impact of education, social groups, and technical advice on household economic status
- Provide policy-relevant insights for agricultural development programs

## Project Structure

```
LandLivestock_Agricultural Households/
├── main.r                          # Main analysis script
├── 01_setup.r                      # Configuration and setup
├── 02_Data_Loading.r              # Data loading functions
├── 03_data_processing.r           # Data cleaning and processing
├── 04_Analysis.r                  # Statistical analysis functions
├── 05_visualisation.r             # Visualization functions
├── agricultural_household_analysis.csv  # Final processed dataset
├── nss77_models.rds               # Saved regression models
├── mpce_by_land_size.png          # Visualization: MPCE by land size
├── mpce_by_education.png          # Visualization: MPCE by education
└── mpce_by_social_group.png       # Visualization: MPCE by social group
```

## Technical Implementation

### Data Sources
- **NSS 77th Round** (2019): Land and Livestock Survey
- **Multiple survey modules**: Demographics, Land Ownership, Technical Advice, Weights
- **Sample**: 20,180 agricultural households across India

### Key Variables

| Variable | Description | Type |
|----------|-------------|------|
| `mpce_per_capita` | Monthly Per Capita Expenditure (Rupees) | Continuous |
| `total_land` | Total land owned (acres) | Continuous |
| `land_size_cat` | Land size categories | Categorical |
| `educ_level` | Education level of household head | Categorical |
| `social_group_f` | Social group (ST, SC, OBC, Others) | Categorical |
| `tech_advice_f` | Received technical advice (Yes/No) | Binary |
| `hh_size` | Household size | Continuous |
| `age_head` | Age of household head | Continuous |
| `gender_f` | Gender of household head | Categorical |

### Methodology

1. **Data Integration**: Merged multiple survey modules using household identifiers
2. **Variable Transformation**: Created meaningful categories and log transformations
3. **Regression Analysis**: 
   - OLS models with robust standard errors
   - Survey-weighted models accounting for complex survey design
4. **Visualization**: Comparative boxplots for key relationships

## 📈 Key Findings

### Regression Results Summary

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

### Survey-Weighted Analysis
- Larger standard errors due to complex survey design
- Land coefficient becomes positive (though insignificant)
- Stronger social group effects observed

## Visualizations

The analysis generates three key visualizations:

1. **MPCE by Land Size**: Shows expenditure distribution across land ownership categories
2. **MPCE by Education**: Demonstrates the education gradient in economic welfare
3. **MPCE by Social Group**: Highlights social disparities in consumption expenditure

## Policy Implications

1. **Education Investment**: Strong returns to education suggest need for continued investment in rural education
2. **Social Inclusion**: Persistent disparities call for targeted interventions for ST/SC households
3. **Technical Advice**: Current extension services may need redesign for greater impact
4. **Land Reforms**: Complex land-welfare relationship warrants further investigation

## How to Run the Analysis

### Prerequisites
```r
# Required R packages
install.packages(c("tidyverse", "haven", "survey", "lmtest", "sandwich", "car"))
```

### Execution
```r
# Run complete analysis
source("main.r")

# Or run step by step
source("01_setup.r")
source("02_Data_Loading.r") 
source("03_data_processing.r")
source("04_Analysis.r")
source("05_visualisation.r")
```

### Data Requirements
- NSS 77th Round data files in specified directory structure
- Required variables as defined in configuration section

## Sample Characteristics

- **Total households**: 20,180
- **Land ownership**: 19,696 households own land
- **Technical advice**: Coverage data for 18,773 households
- **Geographic coverage**: Nationally representative sample

## Limitations

1. **Cross-sectional data**: Cannot establish causality
2. **Land measurement**: Complex relationship with welfare requires deeper analysis
3. **Technical advice**: Binary measure may not capture quality or relevance
4. **Consumption measure**: MPCE as proxy for welfare has limitations

## Future Research Directions

1. **Panel analysis** with follow-up surveys
2. **Quality of technical advice** beyond binary access
3. **Land productivity** measures rather than just area
4. **Regional heterogeneity** analysis
5. **Livestock and other income sources** integration

## Contributors

- Analysis conducted using NSS 77th Round data
- Methodology based on standard survey analysis practices

## License

This project is for academic/research purposes. NSS data subject to MoSPI terms of use.

---

