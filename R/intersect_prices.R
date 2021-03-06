#' Return commmon time series
#'
#' @param prices List of price dataframes
#'
#' @return Input dataframes with common time series to all input dataframes
#'
#' @importFrom purrr reduce
#'
#' @examples
intersect_prices <- function(prices) {
  common_idx <- purrr::map(prices, "date_time") %>%
    purrr::reduce(intersect) %>%
    lubridate::as_datetime()

  if (length(common_idx) == 0) warning("No common datetimes found in prices")

  purrr::map(prices, ~ dplyr::filter(., .data$date_time %in% common_idx))
}
