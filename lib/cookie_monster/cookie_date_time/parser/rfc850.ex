defmodule CookieMonster.CookieDateTime.Parser.RFC850 do
  @moduledoc false

  # 🚨 Edge case alert! 🚨
  # ----------------------
  # This parser handles the deprecated, and hopefully rarely used RFC 850
  # datetime format which uses a 2-digit year.
  #
  # The request to support this format came from one of the users of this
  # library due to Akamai returning cookies with this format from their servers.
  #
  # There's a good reason why this format is bad and was deprecated - how do we
  # know if "Sunday, 06-Nov-94 08:49:37 GMT" means 1994 or 2094??
  #
  # Introducing the Y2K Problem https://en.wikipedia.org/wiki/Year_2000_problem
  #
  # Well there's one clue we can use! On the Wikipedia page for HTTP Cookie it
  # is said that the idea to use it for the web came up in 1994 https://en.wikipedia.org/wiki/HTTP_cookie#History
  #
  # This means that in theory there are no cookies with expiration year of less
  # than 1994.
  #
  # Given all of that I'd say it's _relatively_ safe (for now) to assume that
  # year >= 94 means 199x and year < 90 means 20xx.
  #
  # I truly hope that this old format stops being used by the time this matters.
  # Just to be safe though:
  # - A warning will be logged whenever a guess is made and the likelihood
  #   of the guess being wrong is relatively high (it's unlikely anyone wants to
  #   parse a cookie expiration date from the past)

  require Logger

  alias CookieMonster.CookieDateTime.Parser
  alias CookieMonster.CookieDateTime.Utils

  @behaviour Parser

  # rfc850-date  = weekday "," SP date2 SP time SP "GMT"
  # weekday      = "Monday" | "Tuesday" | "Wednesday" |
  #                "Thursday" | "Friday" | "Saturday" |
  #                "Sunday" | "Mon" | "Tue" | "Wed" |
  #                "Thu" | "Fri" | "Sat" | "Sun"
  # date2        = 2DIGIT "-" month "-" 2DIGIT
  #                ; day-month-year (e.g., 02-Jun-82)
  # time         = 2DIGIT ":" 2DIGIT ":" 2DIGIT
  #                ; 00:00:00 - 23:59:59
  @regex ~r/\w{3,9}, (?<day>\d{2})-(?<month>\w{3})-(?<year>\d{2}) (?<hour>\d{2}):(?<minute>\d{2}):(?<second>\d{2}) GMT/

  @impl Parser
  def parse(str) do
    %{
      "day" => day,
      "month" => month,
      "year" => year,
      "hour" => hour,
      "minute" => minute,
      "second" => second
    } =
      Regex.named_captures(@regex, str)

    %DateTime{
      day: String.to_integer(day),
      month: Utils.find_month_num(month),
      year: year_parser(year),
      hour: String.to_integer(hour),
      minute: String.to_integer(minute),
      second: String.to_integer(second),
      zone_abbr: "UTC",
      time_zone: "Etc/UTC",
      utc_offset: 0,
      std_offset: 0
    }
  end

  @impl Parser
  def regex, do: @regex

  defp year_parser(year_str) do
    year = String.to_integer(year_str)

    guessed_year =
      if year >= 94 do
        warn_about_guess(year)
        "19#{year_str}"
      else
        "20#{year_str}"
      end

    String.to_integer(guessed_year)
  end

  defp warn_about_guess(year) do
    Logger.warning("""
    Guessing cookie expiration year: #{year} as 19#{year}!
    Please update your cookie expiration date to the RFC 1123 format.
    """)
  end
end
