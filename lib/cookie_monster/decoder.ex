defmodule CookieMonster.Decoder do
  @moduledoc """
  Private module for decoding a cookie string. Please use
  `CookieMonster.decode/1` instead.
  """

  alias CookieMonster.Cookie
  alias CookieMonster.CookieDateTime

  @type ok_t :: {:ok, Cookie.t()}
  @type err_t ::
          {:error, :invalid_cookie}
          | {:error, :invalid_cookie_datetime}
          | {:error, :invalid_cookie_samesite}
          | {:error, :invalid_cookie_max_age}

  @type return_t :: ok_t() | err_t()

  @doc false
  @spec decode(String.t()) :: return_t()
  def decode(str) do
    with {:ok, cookie_map} <- build_cookie(str),
         {:ok, parsed_map} <- parse_cookie_values(cookie_map) do
      {:ok, struct!(Cookie, parsed_map)}
    end
  end

  defp build_cookie(str) do
    str |> split_directives() |> build_cookie_map()
  end

  defp build_cookie_map([[name, value] | directives]) do
    fields =
      %{name: name, value: value}
      |> Map.merge(decode_directives(directives))

    {:ok, fields}
  end

  defp build_cookie_map(_anything_else) do
    {:error, :invalid_cookie}
  end

  defp split_directives(cookie) do
    cookie
    |> String.split(~r/;\s*/, trim: true)
    |> Enum.map(&String.split(&1, "=", parts: 2))
  end

  defp decode_directives(directives) do
    directives
    |> Enum.map(&normalize_directive/1)
    |> Enum.map(&directive_to_kv_pair/1)
    |> Enum.into(%{})
  end

  defp normalize_directive([key, value]), do: {String.downcase(key), value}
  defp normalize_directive([key]), do: {String.downcase(key), true}

  defp directive_to_kv_pair({"expires", date}), do: {:expires, date}
  defp directive_to_kv_pair({"max-age", seconds}), do: {:max_age, seconds}
  defp directive_to_kv_pair({"domain", domain}), do: {:domain, domain}
  defp directive_to_kv_pair({"path", path}), do: {:path, path}
  defp directive_to_kv_pair({"secure", true}), do: {:secure, true}
  defp directive_to_kv_pair({"httponly", true}), do: {:http_only, true}
  defp directive_to_kv_pair({"samesite", value}), do: {:same_site, value}

  defp parse_cookie_values(map) do
    with {:ok, same_site} <- parse_same_site(map[:same_site]),
         {:ok, expires} <- parse_expires(map[:expires]),
         {:ok, max_age} <- parse_max_age(map[:max_age]) do
      parsed_map =
        map
        |> Map.put(:same_site, same_site)
        |> Map.put(:expires, expires)
        |> Map.put(:max_age, max_age)

      {:ok, parsed_map}
    end
  end

  defp parse_expires(nil), do: {:ok, nil}
  defp parse_expires(str), do: CookieDateTime.parse(str)

  defp parse_same_site(nil), do: {:ok, nil}

  defp parse_same_site(str) do
    str
    |> String.downcase()
    |> same_site_to_atom()
  end

  defp same_site_to_atom("strict"), do: {:ok, :strict}
  defp same_site_to_atom("lax"), do: {:ok, :lax}
  defp same_site_to_atom("none"), do: {:ok, :none}
  defp same_site_to_atom(_otherwise), do: {:error, :invalid_cookie_samesite}

  defp parse_max_age(nil), do: {:ok, nil}

  defp parse_max_age(str) do
    case Integer.parse(str) do
      {int, _bin} when is_integer(int) -> {:ok, int}
      :error -> {:error, :invalid_cookie_max_age}
    end
  end
end
