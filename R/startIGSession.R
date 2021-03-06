#' Initiate IG Session
#'
#' @param env Which enviroment to use, one of "LIVE" or "DEMO"
#'
#' @return List of session information in global environment
#' @export
#' @importFrom glue glue
#' @importFrom httr add_headers
#' @importFrom httr POST
#' @importFrom utils globalVariables
#'
#' @examples
initiate_ig_session <- function(env = "LIVE") {
  assertthat::assert_that((env %in% c("LIVE", "DEMO")),
    msg = "env must be 'LIVE' or 'DEMO'"
  )

  if (env == "LIVE") {
    Sys.setenv(
      "SESSION_IG_USERNAME" = Sys.getenv("LIVE_IG_USERNAME"),
      "SESSION_IG_PASSWORD" = Sys.getenv("LIVE_IG_PASSWORD"),
      "SESSION_IG_API_KEY" = Sys.getenv("LIVE_IG_API_KEY"),
      "SESSION_IG_HOST" = Sys.getenv("LIVE_IG_HOST")
    )
  } else {
    Sys.setenv(
      "SESSION_IG_USERNAME" = Sys.getenv("DEMO_IG_USERNAME"),
      "SESSION_IG_PASSWORD" = Sys.getenv("DEMO_IG_PASSWORD"),
      "SESSION_IG_API_KEY" = Sys.getenv("DEMO_IG_API_KEY"),
      "SESSION_IG_HOST" = Sys.getenv("DEMO_IG_HOST")
    )
  }

  body <- list(
    identifier = Sys.getenv("SESSION_IG_USERNAME"),
    password = Sys.getenv("SESSION_IG_PASSWORD")
  )

  host <- Sys.getenv('SESSION_IG_HOST')

  session <- httr::POST(
    url = glue::glue("https://{host}/gateway/deal/session"),
    body = body,
    config = httr::add_headers(
      `X-IG-API-KEY` = Sys.getenv("SESSION_IG_API_KEY"),
      `VERSION` = 2
    ),
    encode = "json"
  )

  assertthat::assert_that(session$status_code == 200,
    msg = glue::glue("Response code: {httr::content(session)[[1]]}")
  )

  Sys.setenv("SESSION_X_SECURITY_TOKEN" = session$headers$`x-security-token`)
  Sys.setenv("SESSION_CST" = session$headers$cst)
}
