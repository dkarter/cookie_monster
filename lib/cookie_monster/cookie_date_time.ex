defmodule CookieMonster.CookieDateTime do
  @moduledoc false

  alias CookieMonster.CookieDateTime.Parser
  alias CookieMonster.CookieDateTime.Utils

  @day_names [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ]

  # FIXME: this currently assumes that the datetime is in UTC
  # - In reality no one probably cares, but this should be fixed at some point for
  #   correctness sake. This will require converting timezones which will add
  #   runtime dependencies potentially
  # - Also this should now be much easier now that elixir has strftime function
  #   in calendar

  @doc """
  Formats a datetime into RFC 822 datetime string
  """
  @spec format(DateTime.t()) :: binary()
  def format(%DateTime{} = datetime) do
    %{year: year, month: month, day: day, hour: hour, minute: minute, second: second} = datetime
    {dow_index, 1, 7} = Calendar.ISO.day_of_week(year, month, day, :monday)
    dow = day_of_week(dow_index)
    month = Utils.month_num_to_name(datetime)
    "#{dow}, #{pad(day)} #{month} #{year} #{pad(hour)}:#{pad(minute)}:#{pad(second)} GMT"
  end

  @spec parse(binary()) :: Parser.return_t()
  defdelegate parse(str),
    to: Parser

  defp pad(number) do
    number
    |> to_string()
    |> String.pad_leading(2, "0")
  end

  defp day_of_week(day_of_week), do: Enum.at(@day_names, day_of_week - 1)
end
