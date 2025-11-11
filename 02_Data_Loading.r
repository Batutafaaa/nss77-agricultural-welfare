# =============================================================================
# DATA LOADING FUNCTIONS
# =============================================================================

load_nss_data <- function() {
  cat("Loading NSS 77th Round data files...\n")
  
  # Load Visit 1 files
  data_list$block4_v1 <<- read_sav(paste0(DATA_PATH, "Visit1  Level - 03 (Block 4) - demographic and other particulars of household members  .sav"))
  data_list$block3_v1 <<- read_sav(paste0(DATA_PATH, "Visit1  Level - 02 (Block 3) - demographic and other particulars of household members.sav"))
  data_list$block5_v1 <<- read_sav(paste0(DATA_PATH, "Visit1  Level - 04 (Block 5) - particulars of land of the household and its operation during the period July- December 2018.sav"))
  data_list$block15_v1 <<- read_sav(paste0(DATA_PATH, "Visit 1 Level 17 (Block 15) access to technical advice related to the agricultural activity undertook by the household during the period July - December 2018.sav"))
  
  # Load Visit 2 files
  data_list$block3_v2 <<- read_sav(paste0(DATA_PATH, "Visit2  Level - 02 (Block 3) - demographic and other particulars of household members.sav"))
  data_list$block5_v2 <<- read_sav(paste0(DATA_PATH, "Visit2  Level - 04 (Block 5) - particulars of land of the household and its operation during the period July- December 2018.sav"))
  data_list$block5_complete_v2 <<- read_sav(paste0(DATA_PATH, "Visit 2 Level 19 (Block 5.1) particulars of land of the household and its operation during the period July 2018- June 2019.sav"))
  data_list$block15_v2 <<- read_sav(paste0(DATA_PATH, "Visit 2  Level 17 (Block 15) access to technical advice related to the agricultural activity undertook by the household during the period July - December 2018.sav"))
  
  # Load weights file
  data_list$weights_v2 <<- read_sav(paste0(DATA_PATH, "Visit2  Level - 01 (Block 1) -identification of sample household.sav"))
  
  cat("All files loaded successfully!\n")
}

verify_variables <- function() {
  cat("--- Verifying All Variables Exist ---\n")
  
  check_variable <- function(df, var_name, df_name) {
    if (var_name %in% names(df)) {
      cat("✓", var_name, "found in", df_name, "\n")
      return(TRUE)
    } else {
      cat("✗", var_name, "MISSING in", df_name, "\n")
      available <- grep("^b[0-9]", names(df), value = TRUE)
      if (length(available) > 0) {
        cat("  Available variables:", paste(head(available, 5), collapse = ", "), "\n")
      }
      return(FALSE)
    }
  }
  
  # Check all variables
  check_variable(data_list$block4_v1, VAR_MPCE, "Block 4")
  check_variable(data_list$block4_v1, VAR_HH_SIZE, "Block 4")
  check_variable(data_list$block4_v1, VAR_SOCIAL_GROUP, "Block 4")
  check_variable(data_list$block3_v1, VAR_REL_HEAD, "Block 3")
  check_variable(data_list$block3_v1, VAR_AGE, "Block 3")
  check_variable(data_list$block3_v1, VAR_EDUC, "Block 3")
  check_variable(data_list$block3_v1, VAR_GENDER, "Block 3")
  check_variable(data_list$block5_complete_v2, VAR_LAND_AREA, "Block 5 Complete")
  check_variable(data_list$block5_complete_v2, VAR_LAND_USE_AGRI, "Block 5 Complete")
  check_variable(data_list$weights_v2, VAR_WEIGHT, "Weights")
}