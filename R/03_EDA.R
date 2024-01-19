source("R/00_libraries.R")
source("R/01_functions.R")
source("R/02_generate_data.R")

tidy_stock_data |>
  ggplot(aes(x = Date, y = Adjusted, color = Symbol)) +
  geom_line(
    linewidth = 0.25,
    alpha = 0.8,
    show.legend = FALSE
  ) +
  #expand_limits(y = c(0, 200)) +
  #scale_color_brewer(palette = "Set1") +
  theme_few() +
  theme(
    legend.position = "bottom",
    legend.title = element_blank()
  ) +
  labs(
    title = "Stock Prices",
    subtitle = "Adjusted Closing prices.",
    caption = "Source: Randomly Generated Data | Nitesh Mishra",
    x = NULL,
    y = "Price (INR)"
  ) +
  facet_wrap(~Symbol, ncol = 3, scales = "free_y")

ggsave(
  "price_movement.png",
  path = "img",
  width = 12,
  height = 6
)
