defmodule CookieMonster.Encoder do
  @moduledoc """
  Converts a cookie string from an Elixir Cookie struct into a cookie string
  which can be used in requests as the Cookie header
  """

  alias CookieMonster.Cookie
  alias CookieMonster.CookieDateTime

  @doc """
  Encodes a cookie / map into a string
  """
  @spec encode(Cookie.t() | map(), keyword()) :: {:ok, String.t()} | {:error, :invalid_cookie}
  def encode(cookie, opts \\ [])

  def encode(%{name: name, value: value}, target: :request) do
    {:ok, "#{name}=#{value}"}
  end

  def encode(%{name: name, value: value} = cookie, []) do
    directives =
      cookie
      |> Map.take([:expires, :max_age, :same_site, :domain, :path, :secure, :http_only])
      |> Enum.map(&encode_directive/1)
      |> Enum.reject(&(&1 == nil))

    cookie = ["#{name}=#{value}" | directives] |> Enum.join("; ")

    {:ok, cookie}
  end

  def encode(_, _) do
    {:error, :invalid_cookie}
  end

  defp encode_directive({_, nil}), do: nil
  defp encode_directive({:expires, datetime}), do: "Expires=#{CookieDateTime.format(datetime)}"
  defp encode_directive({:same_site, :strict}), do: "SameSite=Strict"
  defp encode_directive({:same_site, :lax}), do: "SameSite=Lax"
  defp encode_directive({:same_site, :none}), do: "SameSite=Lax"
  defp encode_directive({:path, path}), do: "Path=#{path}"
  defp encode_directive({:domain, domain}), do: "Domain=#{domain}"
  defp encode_directive({:max_age, max_age}), do: "Max-Age=#{max_age}"
  defp encode_directive({:secure, true}), do: "Secure"
  defp encode_directive({:secure, false}), do: nil
  defp encode_directive({:http_only, true}), do: "HttpOnly"
  defp encode_directive({:http_only, false}), do: nil
end
