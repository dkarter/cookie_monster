defmodule CookieMonster.Encoder do
  @moduledoc """
  Private module for decoding a cookie string. Please use
  `CookieMonster.encode/2` instead.
  """

  alias CookieMonster.Cookie
  alias CookieMonster.CookieDateTime

  @type return_t :: {:ok, String.t()} | {:error, :invalid_cookie}

  @doc false
  @spec encode(Cookie.t() | map(), keyword()) :: return_t()
  def encode(cookie, opts \\ [])

  def encode(%{name: name, value: value}, target: :request) do
    {:ok, "#{name}=#{value}"}
  end

  def encode(%{name: name, value: value} = cookie, []) do
    directives =
      cookie
      |> Map.take([:expires, :max_age, :same_site, :domain, :path, :secure, :http_only])
      |> Stream.map(&encode_directive/1)
      |> Stream.reject(&(&1 == nil))
      |> Enum.sort()

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
