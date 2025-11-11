# =============================================================================
# CONFIGURATION AND SETUP
# =============================================================================

# Load required packages
if (!require(tidyverse)) install.packages("tidyverse")
if (!require(haven)) install.packages("haven")
if (!require(survey)) install.packages("survey")
if (!require(lmtest)) install.packages("lmtest")
if (!require(sandwich)) install.packages("sandwich")
if (!require(car)) install.packages("car")

library(tidyverse)
library(haven)
library(survey)
library(lmtest)
library(sandwich)
library(car)

# Set data path - data is in parent folder
DATA_PATH <- "C:/Users/ashwin/Downloads/LandLivestock_Agricultural Households/"

# Key identifying variables
VARS_KEYS <- c("FSU_Slno", "hh_no", "visitNo")

# Variable mappings
VAR_MPCE <- "b4q9"
VAR_HH_SIZE <- "b4q1"
VAR_SOCIAL_GROUP <- "b4q3"
VAR_RELIGION <- "b4q2"
VAR_REL_HEAD <- "b3q3"
VAR_AGE <- "b3q5"
VAR_EDUC <- "b3q6"
VAR_GENDER <- "b3q4"
VAR_LAND_AREA <- "b5pt1q3"
VAR_LAND_USE_AGRI <- "b5pt1q4"
VAR_WEIGHT <- "MLT"

# Initialize empty list to store data
data_list <- list()

cat("Setup configuration loaded successfully!\n")
cat("Data path:", DATA_PATH, "\n")