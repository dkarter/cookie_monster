defmodule CookieMonster do
  @moduledoc """
  A simple HTTP Cookie encoder and decoder written in pure Elixir with zero
  dependencies.

  Follows the standards for cookie headers described in MDN:
  https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies
  """

  alias CookieMonster.Decoder
  alias CookieMonster.Encoder

  @doc """
  Encodes a cookie into a header string
  """
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
  Decodes a Set-Cookie into an Elixir struct
  """
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
