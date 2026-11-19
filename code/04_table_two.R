here::i_am("code/04_table_two.R")

library(here)
library(dplyr)
library(gtsummary)

#---- Read cleaned data -------
f75 <- readRDS(here("data", "f75_interim_clean.rds"))

#---- Create outcome variables -------
table_two_data <- f75 |>
  select(arm, final_outcome, days_stable)

#---- Build the table -------
table_two <- table_two_data |>
  tbl_summary(
    by = arm,
    label = list(
      final_outcome ~ "Final outcome",
      days_stable ~ "Days to stabilization"
    ),
    statistic = list(
      all_continuous() ~ "{median} ({p25}, {p75})",
      all_categorical() ~ "{n} ({p}%)"
    ),
    missing_text = "Did not stabilize"
  ) |>
  add_overall() |>
  bold_labels() |>
  modify_caption("**Table 2. Clinical outcomes by treatment arm**")

#---- Save -------
dir.create(here("output"), showWarnings = FALSE)
saveRDS(table_two, here("output", "table_two.rds"))
