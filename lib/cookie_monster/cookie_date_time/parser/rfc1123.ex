defmodule CookieMonster.CookieDateTime.Parser.RFC1123 do
  @moduledoc false

  alias CookieMonster.CookieDateTime.Parser
  alias CookieMonster.CookieDateTime.Utils

  @behaviour Parser

  # rfc1123-date = wkday "," SP date1 SP time SP "GMT"
  # wkday        = "Mon" | "Tue" | "Wed" | "Thu" | "Fri" | "Sat" | "Sun"
  # date1        = 2DIGIT SP month SP 4DIGIT
  #                ; day month year (e.g., 02 Jun 1982)
  # time         = 2DIGIT ":" 2DIGIT ":" 2DIGIT
  #                ; 00:00:00 - 23:59:59
  @regex ~r/\w{3}, (?<day>\d{2}) (?<month>\w{3}) (?<year>\d{4}) (?<hour>\d{2}):(?<minute>\d{2}):(?<second>\d{2}) GMT/

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
      year: String.to_integer(year),
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
end
