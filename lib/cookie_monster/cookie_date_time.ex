defmodule CookieMonster.CookieDateTime do
  @moduledoc """
  Conveniences for encoding and decoding cookie date time format as described in MDN
  https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Date
  """

  @month_names [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ]

  @day_names [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ]

  @spec format(DateTime.t()) :: String.t()
  def format(%DateTime{} = datetime) do
    %{year: year, month: month, day: day, hour: hour, minute: minute, second: second} = datetime
    dow = Calendar.ISO.day_of_week(year, month, day) |> day_of_week()
    month = month(datetime)
    "#{dow}, #{pad(day)} #{month} #{year} #{pad(hour)}:#{pad(minute)}:#{pad(second)} GMT"
  end

  @spec parse(String.t()) :: DateTime.t()
  def parse(datetime_string) do
    [_, datetime_parts] = String.split(datetime_string, ", ")
    [day, month, year, time, "GMT"] = String.split(datetime_parts, " ")
    [hour, minute, second] = String.split(time, ":")

    %DateTime{
      day: String.to_integer(day),
      month: month(month),
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

  defp pad(number) do
    number
    |> to_string()
    |> String.pad_leading(2, "0")
  end

  defp month(%DateTime{month: month}), do: Enum.at(@month_names, month - 1)
  defp month(month), do: Enum.find_index(@month_names, &(&1 == month)) + 1

  defp day_of_week(day_of_week), do: Enum.at(@day_names, day_of_week - 1)
end
