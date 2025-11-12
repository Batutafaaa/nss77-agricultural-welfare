# =============================================================================
# MAIN ANALYSIS SCRIPT
# =============================================================================
setwd("C:/Users/ashwin/Downloads/LandLivestock_Agricultural Households/New_Script/")

# =============================================================================
# EXPORT FUNCTION (MOVED TO TOP)
# =============================================================================

export_enhanced_results <- function(enhanced_results, filename = "enhanced_analysis_results.RData") {
  cat("\nExporting enhanced analysis results...\n")
  save(enhanced_results, file = filename)
  cat("✓ Results saved to:", filename, "\n")
  
  if (!is.null(enhanced_results$robust$comparison)) {
    write.csv(enhanced_results$robust$comparison, "robust_se_comparison.csv", row.names = FALSE)
    cat("✓ Robust SE comparison saved: 'robust_se_comparison.csv'\n")
  }
  
  cat("✅ Export completed!\n")
}

# Source all modules
source("01_setup.r")
source("02_Data_Loading.r")
source("03_data_processing.r")
source("04_Analysis.r")
source("05_visualisation.r")

# Source the enhanced analysis BEFORE the main execution
source("06_enhanced_analysis.r")

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

# Enhanced analysis function (make sure it's available)
run_enhanced_analysis_option <- function(analysis_df, models) {
  cat("\nWould you like to run enhanced analysis? (y/n): ")
  response <- readline()
  
  if (tolower(response) == "y") {
    cat("Starting enhanced analysis...\n")
    enhanced_results <- run_enhanced_analysis(analysis_df, models)
    return(enhanced_results)
  } else {
    cat("Skipping enhanced analysis\n")
    return(NULL)
  }
}

# Execute the complete analysis
results <- run_complete_analysis()

# Now run the enhanced analysis option
enhanced_results <- run_enhanced_analysis_option(results$analysis_df, results$models)

# If enhanced analysis ran, export those results too
if (!is.null(enhanced_results)) {
  export_enhanced_results(enhanced_results)
  cat("\n🎉 ENHANCED ANALYSIS COMPLETED AND EXPORTED! 🎉\n")
}

cat("\n=== ALL ANALYSES FINISHED ===\n")