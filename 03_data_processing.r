# =============================================================================
# DATA PROCESSING FUNCTIONS
# =============================================================================

process_land_data <- function() {
  cat("Processing land data from Block 5.1...\n")
  
  land_data_fixed <- data_list$block5_complete_v2 %>%
    mutate(
      land_cat_char = as.character(b5pt1q1),
      land_area_num = as.numeric(as.character(b5pt1q3)),
      land_use_char = as.character(b5pt1q4)
    ) %>%
    filter(!is.na(land_area_num), land_area_num > 0) %>%
    group_by(!!!syms(VARS_KEYS)) %>%
    summarize(
      total_land = sum(land_area_num, na.rm = TRUE),
      land_used_agri = sum(ifelse(land_use_char == "1", land_area_num, 0), na.rm = TRUE),
      num_land_parcels = n()
    ) %>%
    ungroup()
  
  cat("Land data processed:", nrow(land_data_fixed), "households with land\n")
  return(land_data_fixed)
}

process_weights_data <- function() {
  cat("Processing weights data...\n")
  
  weights_fixed <- data_list$weights_v2 %>%
    select(!!!syms(VARS_KEYS), !!sym(VAR_WEIGHT)) %>%
    mutate(MLT = as.numeric(as.character(MLT))) %>%
    filter(!is.na(MLT), MLT > 0)
  
  cat("Weights data processed:", nrow(weights_fixed), "households with weights\n")
  return(weights_fixed)
}

process_technical_advice <- function() {
  cat("Processing technical advice data...\n")
  
  tech_vars_all <- grep("^b15", names(data_list$block15_v2), value = TRUE)
  
  tech_visit2_fixed <- data_list$block15_v2 %>%
    mutate(
      across(all_of(tech_vars_all), 
             ~ as.character(.) == "1", 
             .names = "tech_{.col}"),
      received_any_advice = tech_b15q1 | tech_b15q3 | tech_b15q4 | tech_b15q5
    ) %>%
    group_by(!!!syms(VARS_KEYS)) %>%
    summarize(
      received_tech_advice = as.numeric(any(received_any_advice == TRUE, na.rm = TRUE)),
      .groups = 'drop'
    )
  
  cat("Technical advice data processed:", nrow(tech_visit2_fixed), "households\n")
  return(tech_visit2_fixed)
}

process_head_demographics <- function() {
  cat("Processing head demographics...\n")
  
  head_data_visit2 <- data_list$block3_v2 %>%
    mutate(rel_head_char = as.character(!!sym(VAR_REL_HEAD))) %>%
    filter(rel_head_char == "1") %>%
    select(
      !!!syms(VARS_KEYS),
      educ_head = !!sym(VAR_EDUC),
      age_head = !!sym(VAR_AGE),
      gender_head = !!sym(VAR_GENDER)
    ) %>%
    mutate(
      educ_head = as.numeric(as.character(educ_head)),
      age_head = as.numeric(as.character(age_head)),
      gender_head = as.numeric(as.character(gender_head))
    ) %>%
    group_by(!!!syms(VARS_KEYS)) %>%
    slice(1) %>%
    ungroup()
  
  cat("Head demographics processed:", nrow(head_data_visit2), "households\n")
  return(head_data_visit2)
}

create_final_dataset <- function(land_data, weights_data, tech_data, head_data) {
  cat("Creating final analysis dataset...\n")
  
  # Ensure unique keys
  land_data_fixed <- land_data %>% distinct(FSU_Slno, hh_no, visitNo, .keep_all = TRUE)
  weights_data_fixed <- weights_data %>% distinct(FSU_Slno, hh_no, visitNo, .keep_all = TRUE)
  tech_data_fixed <- tech_data %>% distinct(FSU_Slno, hh_no, visitNo, .keep_all = TRUE)
  head_data_fixed <- head_data %>% distinct(FSU_Slno, hh_no, visitNo, .keep_all = TRUE)
  
  # Create base dataset
  base_data <- data_list$block4_v1 %>%
    select(
      FSU_Slno, hh_no, 
      mpce = !!sym(VAR_MPCE),
      hh_size = !!sym(VAR_HH_SIZE),
      social_group = !!sym(VAR_SOCIAL_GROUP),
      religion = !!sym(VAR_RELIGION),
      Stratum
    ) %>%
    mutate(
      mpce = as.numeric(as.character(mpce)),
      hh_size = as.numeric(as.character(hh_size)),
      social_group = as.numeric(as.character(social_group)),
      religion = as.numeric(as.character(religion)),
      Stratum = as.character(Stratum),
      visitNo = "2"
    ) %>%
    filter(!is.na(mpce), !is.na(hh_size), mpce > 0, hh_size > 0) %>%
    distinct(FSU_Slno, hh_no, visitNo, .keep_all = TRUE)
  
  # Merge all datasets
  analysis_df <- base_data %>%
    left_join(head_data_fixed, by = VARS_KEYS) %>%
    left_join(land_data_fixed, by = VARS_KEYS) %>%
    left_join(tech_data_fixed, by = VARS_KEYS) %>%
    left_join(weights_data_fixed, by = VARS_KEYS) %>%
    mutate(
      total_land = ifelse(is.na(total_land), 0, total_land),
      land_used_agri = ifelse(is.na(land_used_agri), 0, land_used_agri),
      num_land_parcels = ifelse(is.na(num_land_parcels), 0, num_land_parcels),
      received_tech_advice = ifelse(is.na(received_tech_advice), 0, received_tech_advice),
      educ_head = ifelse(is.na(educ_head), 1, educ_head),
      age_head = ifelse(is.na(age_head), median(age_head, na.rm = TRUE), age_head),
      gender_head = ifelse(is.na(gender_head), 1, gender_head),
      final_weight = ifelse(is.na(MLT), 1, MLT / 100),
      mpce_per_capita = mpce / hh_size,
      log_mpce = log(pmax(mpce_per_capita, 1)),
      land_size_cat = case_when(
        total_land == 0 ~ "Landless",
        total_land > 0 & total_land <= 1 ~ "Marginal (0-1 acre)",
        total_land > 1 & total_land <= 4 ~ "Small (1-4 acres)", 
        total_land > 4 ~ "Medium/Large (>4 acres)",
        TRUE ~ "Unknown"
      ),
      educ_level = case_when(
        educ_head == 1 ~ "Illiterate",
        educ_head == 2 ~ "Below Primary",
        educ_head == 3 ~ "Primary",
        educ_head == 4 ~ "Middle",
        educ_head == 5 ~ "Secondary",
        educ_head == 6 ~ "Higher Secondary",
        educ_head %in% c(7, 8, 9, 10) ~ "Diploma/Certificate",
        educ_head >= 11 ~ "Graduate+",
        TRUE ~ "Missing"
      ),
      social_group_f = factor(social_group, levels = c(1, 2, 3, 9), labels = c("ST", "SC", "OBC", "Others")),
      tech_advice_f = factor(received_tech_advice, levels = c(0, 1), labels = c("No", "Yes")),
      gender_f = factor(gender_head, levels = c(1, 2), labels = c("Male", "Female")),
      land_size_f = factor(land_size_cat)
    ) %>%
    filter(age_head >= 15) %>%
    distinct(FSU_Slno, hh_no, visitNo, .keep_all = TRUE)
  
  cat("Final dataset created with", nrow(analysis_df), "observations\n")
  return(analysis_df)
}