
#Packages

library(tidyverse)
library(here)

here::i_am("code/03_MUAC_figure.R")

# Load cleaned data
data <- readRDS(here("data/f75_interim_clean.rds"))

# Select variables needed for the figure
nutrition_data <- data %>%
  select(
    subjid, arm,
    muac, muac1, muac2,
    weight, weight1, weight2
  ) %>%
  filter(!is.na(arm))


# Reshape data from wide to long format
nutrition_long <- nutrition_data %>%
  pivot_longer(
    cols = c(muac, muac1, muac2,
             weight, weight1, weight2),
    names_to = "measurement",
    values_to = "value"
  ) %>%
  mutate(
    measure = case_when(
      str_detect(measurement, "^muac") ~ "MUAC (cm)",
      str_detect(measurement, "^weight") ~ "Weight (kg)"
    ),
    timepoint = case_when(
      measurement %in% c("muac", "weight") ~ "Baseline",
      measurement %in% c("muac1", "weight1") ~ "Stabilization",
      measurement %in% c("muac2", "weight2") ~ "Discharge"
    ),
    timepoint = factor(
      timepoint,
      levels = c("Baseline", "Stabilization", "Discharge")
    ),
    arm = factor(arm)
  ) %>%
  filter(!is.na(value))

# Calculate mean and 95% confidence intervals
nutrition_summary <- nutrition_long %>%
  group_by(arm, measure, timepoint) %>%
  summarise(
    n = n(),
    mean_value = mean(value),
    sd_value = sd(value),
    se = sd_value / sqrt(n),
    ci_lower = mean_value - qt(0.975, df = n - 1) * se,
    ci_upper = mean_value + qt(0.975, df = n - 1) * se,
    .groups = "drop"
  )


# Create figure
figure_nutrition <- ggplot(
  nutrition_summary,
  aes(
    x = timepoint,
    y = mean_value,
    color = arm,
    group = arm
  )
) +
  geom_line(linewidth = 1) +
  geom_point(size = 3) +
  geom_errorbar(
    aes(ymin = ci_lower, ymax = ci_upper),
    width = 0.12,
    linewidth = 0.6
  ) +
  facet_wrap(
    ~ measure,
    scales = "free_y",
    ncol = 2
  ) +
  labs(
    title = "Mean MUAC and weight by randomized treatment arm",
    x = "Measurement occasion",
    y = "Mean value",
    color = "Treatment arm",
    caption = paste(
      "Error bars represent 95% confidence intervals.",
      "Sample sizes may differ across measurement occasions."
    )
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold"),
    legend.position = "bottom",
    axis.text.x = element_text(size = 10),
    strip.text = element_text(face = "bold")
  )

# Display figure
print(figure_nutrition)




# Save output

ggsave(
  filename = here("output", "muac.png"),
  plot = figure_nutrition,
  width = 11,
  height = 5.5,
  dpi = 300
)

