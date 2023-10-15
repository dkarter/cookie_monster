defmodule CookieMonster.CookieDateTime.Parser.ASCTIME do
  @moduledoc false

  alias CookieMonster.CookieDateTime.Parser
  alias CookieMonster.CookieDateTime.Utils

  @behaviour Parser

  # asctime = wkday SP date3 SP time SP 4DIGIT
  # wkday  = "Mon" | "Tue" | "Wed" | "Thu" | "Fri" | "Sat" | "Sun"
  # date3  = month SP ( 2DIGIT | ( SP 1DIGIT )) month day (e.g., Jun  2)
  # month  = "Jan" | "Feb" | "Mar" | "Apr" |
  #          "May" | "Jun" | "Jul" | "Aug" |
  #          "Sep" | "Oct" | "Nov" | "Dec"
  @regex ~r/\w{3} (?<month>\w{3})\s{1,2}(?<day>\d{1,2}) (?<hour>\d{2}):(?<minute>\d{2}):(?<second>\d{2}) (?<year>\d{4})/

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
