# =============================================================================
# MAIN ANALYSIS SCRIPT
# =============================================================================

# Source all modules
source("01_setup.r")
source("02_Data_Loading.r")
source("03_data_processing.r")
source("04_Analysis.r")
source("05_visualisation.r")

# Main execution function
run_complete_analysis <- function() {
  cat("Starting NSS 77th Round Analysis...\n")
  cat("Script location: C:/Users/ashwin/Downloads/LandLivestock_Agricultural Households/New_Script/\n")
  
  # Step 1: Load data
  load_nss_data()
  verify_variables()
  
  # Step 2: Process data
  land_data <- process_land_data()
  weights_data <- process_weights_data()
  tech_data <- process_technical_advice()
  head_data <- process_head_demographics()
  
  # Step 3: Create final dataset
  analysis_df <- create_final_dataset(land_data, weights_data, tech_data, head_data)
  
  # Step 4: Run analysis
  models <- run_regression_analysis(analysis_df)
  survey_model <- run_survey_analysis(analysis_df)
  
  # Step 5: Create visualizations
  plots <- create_visualizations(analysis_df)
  
  # Step 6: Save results
  save_results(analysis_df, models)
  
  cat("\n=== ANALYSIS COMPLETED SUCCESSFULLY! ===\n")
  return(list(analysis_df = analysis_df, models = models, plots = plots))
}

# Execute the analysis
results <- run_complete_analysis()