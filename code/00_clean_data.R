#add code here

library(here)
library(readr)
library(dplyr)
library(labelled)

#---- Read raw data -------
here::i_am("code/00_clean_data.R")

f75_raw <- read_csv(here("data/f75_interim_raw.csv"),na = c("", "NA"))

#---- Make readable labels -------

f75_clean <- f75_raw |>
  set_variable_labels(
    agemons = "Age (months)", sex = "Sex", site = "Study site",
    caregiver = "Caregiver", bfeeding = "Breastfeeding",
    hiv_results = "HIV status", kwash = "Kwashiorkor",
    oedema = "Oedema at admission", diarrhoea = "Diarrhoea at admission",
    sev_pneumonia = "Severe pneumonia", malaria = "Malaria", shock = "Shock",
    cerebral_palsy = "Cerebral palsy", weight = "Weight (kg)",
    height = "Height/length (cm)", muac = "MUAC (cm)",
    days_stable = "Days to stabilization",
    arm = "Treatment arm"
  )

#---- Make readable labels -------

saveRDS(f75_clean, here("data/f75_interim_clean.rds"))
