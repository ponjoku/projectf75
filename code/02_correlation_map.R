
library(dplyr)
library(corrplot)
library(readr)
library(here)

here::i_am("code/02_correlation_map.R")

f75_clean <- readRDS(
  here::here("data", "f75_interim_clean.rds"))

# updating data values
binary_data <- f75_clean |>
  transmute(
    sex = ifelse(sex == "Male", 1, 0),
    bfeeding = ifelse(bfeeding == "Yes", 1, 0),
    kwash = ifelse(kwash == "Yes", 1, 0),
    diarrhoea = ifelse(diarrhoea == "Yes", 1, 0),
    sev_pneumonia = ifelse(sev_pneumonia == "Yes", 1, 0),
    malaria = ifelse(malaria == "Yes", 1, 0),
    shock = ifelse(shock == "Yes", 1, 0)
  )

heatmap_vars <- c(
  "agemons" , "sex",  "bfeeding", 
  "hiv_results", "kwash", "oedema", "diarrhoea", 
  "sev_pneumonia", "malaria", "shock", "weight", 
  "height")

phi_matrix <- cor(
  binary_data,
  method = "pearson",
  use = "pairwise.complete.obs")

saveRDS(
  phi_matrix,
  here::here("output", "phi_matrix.rds")
)


corrplot(
  phi_matrix,
  method = "color",
  type = "lower",
  col = colorRampPalette(c("white", "red"))(200),
  addCoef.col = "black",
  number.cex = 0.5,
  tl.col = "black",
  tl.srt = 90,
  tl.pos = "lt",
  diag = FALSE
)


