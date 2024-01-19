# Set a seed for reproducibility
set.seed(42)

# Function to generate fake stock prices for a company
generate_stock_prices <- function(num_days, start_date, end_date) {


  # Generate business days
  business_days <- generate_business_days(start_date, end_date)

  # Number of trading days
  num_days <- length(business_days)

  # Generate random daily returns
  daily_returns <- rnorm(num_days, mean = 0.0005, sd = 0.01)

  # Calculate cumulative returns
  cumulative_returns <- cumsum(daily_returns)

  # Set an initial stock price
  initial_price <- 100

  # Calculate stock prices
  stock_prices <- initial_price * exp(cumulative_returns)

  # Calculate open, close, low, high, and adjusted prices
  open_prices <- stock_prices * (1 + 0.02 * rnorm(num_days))
  close_prices <- open_prices * (1 + 0.02 * rnorm(num_days))

  # Ensure low price is not higher than close price
  low_prices <- close_prices * (1 - 0.01 * rnorm(num_days))

  # Ensure high price is not lower than close price or open price
  high_prices <- close_prices * (1 + 0.01 * rnorm(num_days))

  # Introduce strong trading days
  strong_trading_days <- sample(1:num_days, size = round(0.1 * num_days))
  open_prices[strong_trading_days] <- open_prices[strong_trading_days] * (1 + 0.02)
  high_prices[strong_trading_days] <- high_prices[strong_trading_days] * (1 + 0.02)

  # Introduce strong selling days
  strong_selling_days <- sample(1:num_days, size = round(0.1 * num_days))
  close_prices[strong_selling_days] <- close_prices[strong_selling_days] * (1 - 0.02)

  adjusted_prices <- close_prices * (1 + 0.005 * rnorm(num_days))

  # Generate random volume of shares traded
  volume <- sample(1000:10000, num_days, replace = TRUE)

  # Smooth the volume using a simple moving average
  smooth_volume <- stats::filter(volume, rep(1/5, 5), sides = 2)

  # Create a data frame with all prices and volume
  stock_data <- data.frame(
    Date = business_days,
    Open = open_prices,
    Close = close_prices,
    Low = low_prices,
    High = high_prices,
    Adjusted = adjusted_prices,
    Volume = smooth_volume
  )

  return(stock_data)
}

# Function to generate random 4-character symbols
generate_symbols <- function(num_symbols) {
  symbols <- replicate(num_symbols, paste0(sample(LETTERS, 6, replace = TRUE), collapse = ""))
  return(symbols)
}

# Function to generate business days within a date range
generate_business_days <- function(start_date, end_date) {
  all_days <- seq(as.Date(start_date), as.Date(end_date), by = "day")
  business_days <- all_days[weekdays(all_days) %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday")]
  return(business_days)
}

# Function to generate tidy stock data frame
generate_tidy_stock_data <- function(num_companies, start_date, end_date) {
  tidy_stock_data <- tibble()

  symbols <- generate_symbols(num_companies)

  for (i in 1:num_companies) {
    company_data <- generate_stock_prices(num_days = 252, start_date = start_date, end_date = end_date)
    company_data$Symbol <- symbols[i]
    tidy_stock_data <- bind_rows(tidy_stock_data, company_data)
  }

  return(tidy_stock_data)
}
