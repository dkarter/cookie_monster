defmodule CookieMonster.Decoder do
  @moduledoc """
  Converts a cookie string from a response's Set-Cookie header to an Elixir struct
  """

  alias CookieMonster.Cookie
  alias CookieMonster.CookieDateTime

  @spec decode(String.t()) :: {:ok, Cookie.t()}
  def decode(cookie) do
    [[key, value] | directives] =
      cookie
      |> String.split(~r/;\s*/, trim: true)
      |> Enum.map(&String.split(&1, "=", parts: 2))

    fields =
      %{
        name: key,
        value: value
      }
      |> Map.merge(decode_directives(directives))

    {:ok, struct!(Cookie, fields)}
  end

  defp decode_directives(directives) do
    directives
    |> Enum.map(&normalize_directive/1)
    |> Enum.map(&directive_to_kv_pair/1)
    |> Enum.into(%{})
  end

  defp normalize_directive([key, value]), do: {String.downcase(key), value}
  defp normalize_directive([key]), do: {String.downcase(key), true}

  defp directive_to_kv_pair({"expires", date}), do: {:expires, CookieDateTime.parse(date)}
  defp directive_to_kv_pair({"max-age", date}), do: {:max_age, date}
  defp directive_to_kv_pair({"domain", domain}), do: {:domain, domain}
  defp directive_to_kv_pair({"path", path}), do: {:path, path}
  defp directive_to_kv_pair({"secure", true}), do: {:secure, true}
  defp directive_to_kv_pair({"httponly", true}), do: {:http_only, true}

  defp directive_to_kv_pair({"samesite", value}) do
    {:same_site, value |> String.downcase() |> same_site_to_atom()}
  end

  defp same_site_to_atom("strict"), do: :strict
  defp same_site_to_atom("lax"), do: :lax
  defp same_site_to_atom("none"), do: :none
end
