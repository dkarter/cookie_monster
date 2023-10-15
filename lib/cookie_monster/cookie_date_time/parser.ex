defmodule CookieMonster.CookieDateTime.Parser do
  @moduledoc false

  # All HTTP date/time stamps MUST be represented in Greenwich Mean Time
  # (GMT), without exception. For the purposes of HTTP, GMT is exactly
  # equal to UTC (Coordinated Universal Time). This is indicated in the
  # first two formats by the inclusion of "GMT" as the three-letter
  # abbreviation for time zone, and MUST be assumed when reading the
  # asctime format. HTTP-date is case sensitive and MUST NOT include
  # additional LWS beyond that specifically included as SP in the
  # grammar.
  #
  #     HTTP-date    = rfc1123-date | rfc850-date | asctime-date
  #     rfc1123-date = wkday "," SP date1 SP time SP "GMT"
  #     rfc850-date  = weekday "," SP date2 SP time SP "GMT"
  #     asctime-date = wkday SP date3 SP time SP 4DIGIT
  #     date1        = 2DIGIT SP month SP 4DIGIT
  #                    ; day month year (e.g., 02 Jun 1982)
  #     date2        = 2DIGIT "-" month "-" 2DIGIT
  #                    ; day-month-year (e.g., 02-Jun-82)
  #     date3        = month SP ( 2DIGIT | ( SP 1DIGIT ))
  #                    ; month day (e.g., Jun  2)
  #     time         = 2DIGIT ":" 2DIGIT ":" 2DIGIT
  #                    ; 00:00:00 - 23:59:59
  #     wkday        = "Mon" | "Tue" | "Wed"
  #                  | "Thu" | "Fri" | "Sat" | "Sun"
  #     weekday      = "Monday" | "Tuesday" | "Wednesday"
  #                  | "Thursday" | "Friday" | "Saturday" | "Sunday"
  #     month        = "Jan" | "Feb" | "Mar" | "Apr"
  #                  | "May" | "Jun" | "Jul" | "Aug"
  #                  | "Sep" | "Oct" | "Nov" | "Dec"
  # Source: https://www.rfc-editor.org/rfc/rfc2616#section-3.3.1

  @callback parse(binary()) :: DateTime.t()
  @callback regex() :: Regex.t()

  alias CookieMonster.CookieDateTime.Parser.ASCTIME
  alias CookieMonster.CookieDateTime.Parser.RFC1123
  alias CookieMonster.CookieDateTime.Parser.RFC850

  @type return_t :: {:ok, DateTime.t()} | {:error, :invalid_cookie_datetime}

  @spec parse(binary()) :: return_t()
  def parse(str) do
    # Find the matching parser and parse
    [
      # This is the current widely used standard format
      RFC1123,

      # This is the obsolete format still used by some vendors aka Akamai
      RFC850,

      # This is the ANSI C's asctime() format, I'm not sure where it is used,
      # but there are probably some C libs out there that some vendors use and
      # it is still listed as a potential format
      ASCTIME
    ]
    |> Enum.find(&parser_matches?(&1, str))
    |> case do
      nil -> {:error, :invalid_cookie_datetime}
      mod when is_atom(mod) -> {:ok, mod.parse(str)}
    end
  end

  defp parser_matches?(parser, str) do
    Regex.match?(parser.regex(), str)
  end
end
