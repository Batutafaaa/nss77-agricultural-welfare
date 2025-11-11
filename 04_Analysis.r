# =============================================================================
# ANALYSIS FUNCTIONS
# =============================================================================

run_regression_analysis <- function(analysis_df) {
  cat("
--- Running Regression Analysis ---
")
  
  if(nrow(analysis_df) > 100) {
    # Model 1: Basic determinants
    cat("Model 1: Basic Determinants
")
    model1 <- lm(log_mpce ~ educ_level + total_land + hh_size + social_group_f, data = analysis_df)
    
    # Model 2: With technical advice
    cat("
Model 2: With Technical Advice
")
    model2 <- lm(log_mpce ~ educ_level + total_land + hh_size + social_group_f + tech_advice_f, data = analysis_df)
    
    # Model 3: Comprehensive model
    cat("
Model 3: Comprehensive Model
")
    model3 <- lm(log_mpce ~ educ_level + total_land + hh_size + social_group_f + 
                   tech_advice_f + age_head + gender_f, data = analysis_df)
    
    models <- list(model1 = model1, model2 = model2, model3 = model3)
    
    # Print summaries
    print(summary(model1))
    print(summary(model2))
    print(summary(model3))
    
    return(models)
  } else {
    cat("Insufficient data for analysis
")
    return(NULL)
  }
}

run_survey_analysis <- function(analysis_df) {
  cat("
--- Running Survey Analysis ---
")
  
  if (sum(!is.na(analysis_df$final_weight)) > 100 && 
      length(unique(analysis_df$Stratum)) > 1) {
    
    options(survey.lonely.psu = "adjust")
    
    svy_design <- svydesign(
      ids = ~FSU_Slno,
      strata = ~Stratum,
      weights = ~final_weight,
      data = analysis_df,
      nest = TRUE
    )
    
    model_svy <- svyglm(log_mpce ~ educ_level + total_land + hh_size + social_group_f,
                        design = svy_design)
    print(summary(model_svy))
    
    return(model_svy)
  } else {
    cat("Insufficient data for survey analysis
")
    return(NULL)
  }
}

save_results <- function(analysis_df, models) {
  # Save dataset
  write_csv(analysis_df, "agricultural_household_analysis.csv")
  
  # Save models
  if (!is.null(models)) {
    saveRDS(models, "nss77_models.rds")
  }
  
  cat("Results saved to current directory
")
}
