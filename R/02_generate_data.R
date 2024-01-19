source("R/00_libraries.R")
source("R/01_functions.R")

# User inputs
num_companies_input <- 12
start_date_input <- "2022-01-01"
end_date_input <- "2023-12-31"

# Generate tidy stock data
tidy_stock_data <- generate_tidy_stock_data(num_companies_input,
                                            start_date_input,
                                            end_date_input)
