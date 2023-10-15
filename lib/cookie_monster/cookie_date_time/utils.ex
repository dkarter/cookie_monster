defmodule CookieMonster.CookieDateTime.Utils do
  @moduledoc false

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

  @doc """
  Finds the month name by number

  ## Examples

  Using a DateTime:

    iex> date = DateTime.utc_now() |> Map.put(:month, 1)
    iex> month_num_to_name(date)
    "Jan"

    iex> date = DateTime.utc_now() |> Map.put(:month, 7)
    iex> month_num_to_name(date)
    "Jul"

    iex> date = DateTime.utc_now() |> Map.put(:month, 12)
    iex> month_num_to_name(date)
    "Dec"

  Using integer (1-based index):

    iex> month_num_to_name(1)
    "Jan"

    iex> month_num_to_name(7)
    "Jul"

    iex> month_num_to_name(12)
    "Dec"
  """
  @spec month_num_to_name(DateTime.t() | integer()) :: binary()
  def month_num_to_name(%DateTime{month: month}) do
    Enum.at(@month_names, month - 1)
  end

  def month_num_to_name(num) when is_integer(num) do
    Enum.at(@month_names, num - 1)
  end

  @doc """
  Finds the month number based on its abbreviated name

  ## Examples

    iex> find_month_num("Jan")
    1

    iex> find_month_num("Jul")
    7

    iex> find_month_num("Dec")
    12
  """
  @spec find_month_num(binary()) :: integer()
  def find_month_num(month) do
    Enum.find_index(@month_names, &(&1 == month)) + 1
  end
end
