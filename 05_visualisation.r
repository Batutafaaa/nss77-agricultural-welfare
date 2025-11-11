# =============================================================================
# VISUALIZATION FUNCTIONS
# =============================================================================

create_visualizations <- function(analysis_df) {
  cat("\n--- Creating Visualizations ---\n")
  
  # Plot 1: MPCE by Land Size
  p1 <- ggplot(analysis_df, aes(x = land_size_f, y = mpce_per_capita)) +
    geom_boxplot(fill = "lightblue", alpha = 0.7) +
    labs(title = "Monthly Per Capita Expenditure by Land Size",
         subtitle = paste("N =", format(nrow(analysis_df), big.mark = ","), "agricultural households"),
         x = "Land Size Category", 
         y = "MPCE (Rupees)") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  # Plot 2: MPCE by Education
  p2 <- ggplot(analysis_df, aes(x = educ_level, y = mpce_per_capita)) +
    geom_boxplot(fill = "lightgreen", alpha = 0.7) +
    labs(title = "Monthly Per Capita Expenditure by Education Level",
         subtitle = paste("N =", format(nrow(analysis_df), big.mark = ","), "agricultural households"),
         x = "Education Level", 
         y = "MPCE (Rupees)") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  # Plot 3: MPCE by Social Group
  p3 <- ggplot(analysis_df, aes(x = social_group_f, y = mpce_per_capita, fill = social_group_f)) +
    geom_boxplot(alpha = 0.7) +
    labs(title = "Monthly Per Capita Expenditure by Social Group",
         subtitle = paste("N =", format(nrow(analysis_df), big.mark = ","), "agricultural households"),
         x = "Social Group", 
         y = "MPCE (Rupees)") +
    theme_minimal() +
    theme(legend.position = "none")
  
  # Save plots
  ggsave("mpce_by_land_size.png", p1, width = 10, height = 6)
  ggsave("mpce_by_education.png", p2, width = 10, height = 6)
  ggsave("mpce_by_social_group.png", p3, width = 10, height = 6)
  
  cat("Visualizations saved as PNG files\n")
  return(list(p1 = p1, p2 = p2, p3 = p3))
}