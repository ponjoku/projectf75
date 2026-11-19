#---- Table 1: Baseline characteristics by treatment arm -------
# Author: Pavithra
# Input:  data/f75_interim_clean.rds
# Output: output/table_one.rds

here::i_am("code/01_table_one.R")

library(here)
library(dplyr)
library(gtsummary)

#---- Read cleaned data -------
f75 <- readRDS(here("data", "f75_interim_clean.rds"))

#---- Pick baseline variables -------
table_one_data <- f75 |>
  select(
    arm, agemons, sex, site, caregiver, bfeeding, hiv_results,
    weight, height, muac, oedema, kwash,
    diarrhoea, sev_pneumonia, malaria, shock
  )

#---- Build the table -------
table_one <- table_one_data |>
  tbl_summary(
    by = arm,
    label = list(
      agemons ~ "Age (months)",
      sex ~ "Sex",
      site ~ "Study site",
      caregiver ~ "Caregiver",
      bfeeding ~ "Breastfeeding",
      hiv_results ~ "HIV status",
      weight ~ "Weight (kg)",
      height ~ "Height/length (cm)",
      muac ~ "MUAC (cm)",
      oedema ~ "Oedema at admission",
      kwash ~ "Kwashiorkor",
      diarrhoea ~ "Diarrhoea at admission",
      sev_pneumonia ~ "Severe pneumonia",
      malaria ~ "Malaria",
      shock ~ "Shock"
    ),
    statistic = list(
      all_continuous() ~ "{median} ({p25}, {p75})",
      all_categorical() ~ "{n} ({p}%)"
    ),
    missing_text = "Missing"
  ) |>
  add_overall() |>
  bold_labels() |>
  modify_caption("**Table 1. Baseline characteristics by treatment arm**")

#---- Save -------
dir.create(here("output"), showWarnings = FALSE)
saveRDS(table_one, here("output", "table_one.rds"))
