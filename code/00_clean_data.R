#add code here

library(here)
library(readr)
library(dplyr)
library(labelled)

#---- Read raw data -------
here::i_am("code/00_clean_data.R")

f75_raw <- read_csv(here("data/f75_interim_raw.csv"),na = c("", "NA"))

#---- Create outcome variables -------
f75_clean <- f75_raw |>
  mutate(
    # final outcome: discharged, died, or withdrew
    final_outcome = case_when(
      discharged2 == "Yes" ~ "Discharged",
      withdraw2 == "died" ~ "Died",
      TRUE ~ "Withdrew"
    ),
    final_outcome = factor(final_outcome, levels = c("Discharged", "Died", "Withdrew")),
    
    # 999 means the child never stabilized, so set to missing
    days_stable = ifelse(days_stable == 999, NA, days_stable)
  )

#---- Make readable labels -------

f75_clean <- f75_clean |>
  set_variable_labels(
    agemons = "Age (months)", sex = "Sex", site = "Study site",
    caregiver = "Caregiver", bfeeding = "Breastfeeding",
    hiv_results = "HIV status", kwash = "Kwashiorkor",
    oedema = "Oedema at admission", diarrhoea = "Diarrhoea at admission",
    sev_pneumonia = "Severe pneumonia", malaria = "Malaria", shock = "Shock",
    cerebral_palsy = "Cerebral palsy", weight = "Weight (kg)",
    height = "Height/length (cm)", muac = "MUAC (cm)",
    days_stable = "Days to stabilization",final_outcome = "Final outcome",
    arm = "Treatment arm"
  )

#---- Make readable labels -------

saveRDS(f75_clean, here("data/f75_interim_clean.rds"))

