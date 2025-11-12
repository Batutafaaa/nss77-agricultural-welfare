# =============================================================================
# 06_ENHANCED_ANALYSIS.R - CLEAN VERSION
# Enhanced analytical techniques for NSS 77th Round data
# =============================================================================

# Load required packages
if (!require(car)) install.packages("car")
if (!require(lmtest)) install.packages("lmtest")
if (!require(sandwich)) install.packages("sandwich")
if (!require(ggplot2)) install.packages("ggplot2")
if (!require(dplyr)) install.packages("dplyr")
if (!require(broom)) install.packages("broom")

library(car)
library(lmtest)
library(sandwich)
library(ggplot2)
library(dplyr)
library(broom)

# =============================================================================
# 1. MODEL DIAGNOSTICS
# =============================================================================

run_model_diagnostics <- function(models, analysis_df) {
  cat("\n=== MODEL DIAGNOSTICS AND VALIDATION ===\n")
  
  if (is.null(models)) {
    cat("No models available for diagnostics\n")
    return(NULL)
  }
  
  model3 <- models$model3
  
  # 1. Variance Inflation Factors
  cat("\n1. Multicollinearity Check (VIF):\n")
  vif_values <- car::vif(model3)
  print(round(vif_values, 2))
  
  max_vif <- max(vif_values)
  if (max_vif > 10) {
    cat("WARNING: High multicollinearity detected (VIF > 10)\n")
  } else if (max_vif > 5) {
    cat("CAUTION: Moderate multicollinearity detected (VIF > 5)\n")
  } else {
    cat("No serious multicollinearity issues detected\n")
  }
  
  # 2. Heteroskedasticity Test
  cat("\n2. Heteroskedasticity Test (Breusch-Pagan):\n")
  bp_test <- lmtest::bptest(model3)
  print(bp_test)
  
  if (bp_test$p.value < 0.05) {
    cat("Heteroskedasticity detected (p < 0.05)\n")
    cat("Recommendation: Use robust standard errors\n")
  } else {
    cat("No significant heteroskedasticity detected\n")
  }
  
  # 3. Normality of Residuals
  cat("\n3. Normality Test (Shapiro-Wilk on sample):\n")
  sample_size <- min(5000, length(residuals(model3)))
  sample_residuals <- sample(residuals(model3), sample_size)
  shapiro_test <- shapiro.test(sample_residuals)
  print(shapiro_test)
  
  if (shapiro_test$p.value < 0.05) {
    cat("Non-normality detected (p < 0.05)\n")
    cat("Note: With large samples, OLS is robust to non-normality\n")
  } else {
    cat("Residuals approximately normal\n")
  }
  
  # 4. Influential Observations
  cat("\n4. Influential Observations:\n")
  cooks_d <- cooks.distance(model3)
  threshold <- 4/nrow(analysis_df)
  influential_count <- sum(cooks_d > threshold, na.rm = TRUE)
  
  cat("Cook's Distance threshold:", round(threshold, 6), "\n")
  cat("Number of influential observations:", influential_count, "\n")
  cat("Percentage of data:", round(influential_count/nrow(analysis_df)*100, 2), "%\n")
  
  if (influential_count > nrow(analysis_df) * 0.05) {
    cat("High proportion of influential observations (>5%)\n")
  }
  
  return(list(
    vif = vif_values,
    bp_test = bp_test,
    shapiro_test = shapiro_test,
    influential_obs = influential_count
  ))
}

# =============================================================================
# 2. ROBUST STANDARD ERRORS
# =============================================================================

run_robust_regression <- function(analysis_df) {
  cat("\n=== ROBUST STANDARD ERRORS ANALYSIS ===\n")
  
  model_robust <- lm(log_mpce ~ educ_level + total_land + hh_size + 
                       social_group_f + tech_advice_f + age_head + gender_f, 
                     data = analysis_df)
  
  # Calculate heteroskedasticity-consistent standard errors
  robust_se <- sandwich::vcovHC(model_robust, type = "HC3")
  robust_results <- lmtest::coeftest(model_robust, vcov = robust_se)
  
  cat("\nRobust Standard Errors (HC3):\n")
  print(robust_results)
  
  # Compare OLS vs Robust SEs
  cat("\nComparison: OLS vs Robust Standard Errors:\n")
  ols_se <- sqrt(diag(vcov(model_robust)))
  robust_se_diag <- sqrt(diag(robust_se))
  
  comparison <- data.frame(
    Variable = names(coef(model_robust)),
    OLS_SE = round(ols_se, 4),
    Robust_SE = round(robust_se_diag, 4),
    Ratio = round(robust_se_diag / ols_se, 3)
  )
  
  print(comparison)
  
  return(list(
    model = model_robust,
    robust_results = robust_results,
    comparison = comparison
  ))
}

# =============================================================================
# 3. ENHANCED VISUALIZATIONS
# =============================================================================

create_enhanced_visualizations <- function(analysis_df, models) {
  cat("\n=== CREATING ENHANCED VISUALIZATIONS ===\n")
  
  # Plot 1: Coefficient plot with CI
  if (!is.null(models)) {
    model_data <- broom::tidy(models$model3, conf.int = TRUE) %>%
      filter(term != "(Intercept)") %>%
      mutate(term = gsub("educ_level|social_group_f|tech_advice_f|gender_f", "", term))
    
    p1 <- ggplot(model_data, aes(x = reorder(term, estimate), y = estimate)) +
      geom_point(size = 3, color = "steelblue") +
      geom_errorbar(aes(ymin = conf.low, ymax = conf.high), 
                    width = 0.2, color = "steelblue") +
      geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
      coord_flip() +
      labs(title = "Regression Coefficients with 95% Confidence Intervals",
           x = "", y = "Coefficient Estimate") +
      theme_minimal()
    
    ggsave("enhanced_coef_plot.png", p1, width = 10, height = 8, dpi = 300)
    cat("Saved: enhanced_coef_plot.png\n")
  }
  
  # Plot 2: MPCE distribution by education
  p2 <- ggplot(analysis_df, aes(x = educ_level, y = mpce_per_capita)) +
    geom_boxplot(fill = "lightblue") +
    scale_y_log10(labels = scales::comma) +
    labs(title = "MPCE Distribution by Education Level",
         x = "Education Level", y = "MPCE (Rs.)") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  ggsave("enhanced_mpce_by_education.png", p2, width = 10, height = 8, dpi = 300)
  cat("Saved: enhanced_mpce_by_education.png\n")
  
  # Plot 3: Land vs MPCE by social group
  p3 <- analysis_df %>%
    filter(total_land > 0 & total_land < 20) %>%
    ggplot(aes(x = total_land, y = mpce_per_capita, color = social_group_f)) +
    geom_smooth(method = "loess", se = TRUE) +
    scale_y_log10(labels = scales::comma) +
    labs(title = "Land-MPCE Relationship by Social Group",
         x = "Total Land (acres)", y = "MPCE (Rs.)",
         color = "Social Group") +
    theme_minimal()
  
  ggsave("enhanced_land_mpce_by_group.png", p3, width = 10, height = 8, dpi = 300)
  cat("Saved: enhanced_land_mpce_by_group.png\n")
  
  return(TRUE)
}

# =============================================================================
# 4. MAIN ENHANCED ANALYSIS FUNCTION
# =============================================================================

run_enhanced_analysis <- function(analysis_df, models) {
  cat("\n╔════════════════════════════════════════════════════════════════╗\n")
  cat("║           COMPREHENSIVE ENHANCED ANALYSIS                      ║\n")
  cat("╚════════════════════════════════════════════════════════════════╝\n")
  
  enhanced_results <- list()
  
  # 1. Model Diagnostics
  cat("\n【1】 RUNNING MODEL DIAGNOSTICS\n")
  enhanced_results$diagnostics <- run_model_diagnostics(models, analysis_df)
  
  # 2. Robust Standard Errors
  cat("\n【2】 RUNNING ROBUST STANDARD ERRORS\n")
  enhanced_results$robust <- run_robust_regression(analysis_df)
  
  # 3. Enhanced Visualizations
  cat("\n【3】 CREATING ENHANCED VISUALIZATIONS\n")
  enhanced_results$visualizations <- create_enhanced_visualizations(analysis_df, models)
  
  cat("\n✅ ENHANCED ANALYSIS COMPLETED SUCCESSFULLY!\n")
  cat("✓ Model diagnostics and validation\n")
  cat("✓ Robust standard errors\n")
  cat("✓ Enhanced visualizations\n")
  
  return(enhanced_results)
}

# =============================================================================
# EXECUTION HELPER
# =============================================================================

# Helper function to run enhanced analysis with current data
run_enhanced_with_current_data <- function() {
  if (!exists("analysis_df") || !exists("models")) {
    cat("Error: analysis_df or models not found in environment.\n")
    cat("Please run the basic analysis first.\n")
    return(NULL)
  }
  
  cat("Running enhanced analysis with current data...\n")
  return(run_enhanced_analysis(analysis_df, models))
}

cat("Enhanced analysis functions loaded successfully!\n")
cat("Use run_enhanced_analysis(analysis_df, models) to run the analysis.\n")
cat("Or use run_enhanced_with_current_data() if data is already loaded.\n")
