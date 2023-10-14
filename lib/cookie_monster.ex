defmodule CookieMonster do
  @moduledoc """
  A simple HTTP Cookie encoder and decoder written in pure Elixir with zero
  dependencies.

  Follows the standards for cookie headers described in MDN:
  https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies
  """

  alias CookieMonster.Cookie
  alias CookieMonster.Decoder
  alias CookieMonster.Encoder

  @doc """
  Encodes a cookie struct into a header string

  ## Example

      iex> cookie = %CookieMonster.Cookie{
      ...>   name: "id",
      ...>   value: "a3fWa",
      ...>   expires: ~U[2015-10-21 07:28:00Z],
      ...>   http_only: true,
      ...>   secure: true
      ...> }
      iex> CookieMonster.encode(cookie)
      {:ok, "id=a3fWa; Expires=Wed, 21 Oct 2015 07:28:00 GMT; HttpOnly; Secure"}
  """
  @spec encode(Cookie.t() | map(), keyword()) :: Encoder.return_t()
  defdelegate encode(cookie, opts), to: Encoder
  defdelegate encode(cookie), to: Encoder

  @spec encode!(Cookie.t()) :: String.t()
  def encode!(cookie, opts \\ []) do
    case encode(cookie, opts) do
      {:ok, encoded_cookie} -> encoded_cookie
      {:error, error} -> raise error
    end
  end

  @doc """
  Decodes a Set-Cookie header text into an Elixir struct

  ## Example

      iex> header = "id=a3fWa; Expires=Wed, 21 Oct 2015 07:28:00 GMT; Secure; HttpOnly"
      ...> {:ok, cookie} = CookieMonster.decode(header)
      ...> cookie
      %CookieMonster.Cookie{
        value: "a3fWa",
        expires: ~U[2015-10-21 07:28:00Z],
        http_only: true,
        name: "id",
        secure: true
      }
  """
  @spec decode(String.t()) :: Decoder.return_t()
  defdelegate decode(cookie_string), to: Decoder

  @doc """
  Decodes a Set-Cookie Header into an Elixir struct

  Similar to `decode/1` except it will unwrap the error tuple and raise
  in case of errors.
  """
  @spec decode!(String.t()) :: Cookie.t()
  def decode!(cookie) do
    case decode(cookie) do
      {:ok, decoded_cookie} -> decoded_cookie
      {:error, error} -> raise error
    end
  end
end
