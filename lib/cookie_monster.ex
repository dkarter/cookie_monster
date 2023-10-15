defmodule CookieMonster do
  @moduledoc """
  A simple HTTP Cookie encoder and decoder written in pure Elixir with zero
  dependencies.

  Follows the standards for cookie headers described in MDN:
  https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies
  """

  use Boundary, deps: [Logger], exports: [Cookie]

  alias CookieMonster.Cookie
  alias CookieMonster.Decoder
  alias CookieMonster.Encoder

  @doc """
  Encodes a cookie struct into a header string

  ## Arguments
  - `cookie`: a string representation of a cookie
  - `opts`: an optional keyword list containing
    - `target: :request` - build a cookie for use in a request (containing only
       name and value pair)

  ## Returns
  When successful, an `{:ok, cookie}` tuple where `cookie` is a string representation of the
  cookie. Dates are formatted using the [RFC 1123 spec](https://www.rfc-editor.org/rfc/rfc2616#section-3.3.1).

  Otherwise, returns an `{:error, atom}`, consult the types for more info.

  ## Examples

      iex> cookie = %CookieMonster.Cookie{
      ...>   name: "id",
      ...>   value: "a3fWa",
      ...>   expires: ~U[2015-10-21 07:28:00Z],
      ...>   http_only: true,
      ...>   secure: true
      ...> }
      iex> CookieMonster.encode(cookie)
      {:ok, "id=a3fWa; Expires=Wed, 21 Oct 2015 07:28:00 GMT; HttpOnly; Secure"}


      iex> cookie = %CookieMonster.Cookie{
      ...>   name: "id",
      ...>   value: "a3fWa",
      ...>   expires: ~U[2015-10-21 07:28:00Z],
      ...>   http_only: true,
      ...>   secure: true
      ...> }
      iex> CookieMonster.encode(cookie, target: :request)
      {:ok, "id=a3fWa"}
  """
  @spec encode(Cookie.t() | map(), keyword()) :: Encoder.return_t()
  defdelegate encode(cookie, opts \\ []), to: Encoder

  @doc """
  Similar to `encode/2`, but an `ArgumentError` exception is raised
  if the cookie cannot be encoded.
  """
  @spec encode!(Cookie.t(), keyword()) :: String.t()
  def encode!(cookie, opts \\ []) do
    case encode(cookie, opts) do
      {:ok, encoded_cookie} -> encoded_cookie
      {:error, error} -> raise ArgumentError, Atom.to_string(error)
    end
  end

  @doc """
  Decodes a Set-Cookie header text into an Elixir struct

  Supports all valid expires date formats in the following spec standards:
  - RFC 1123
  - RFC 850 (despite being deprecated it is still considered valid)
    - This format does pose some Y2K concerns due to the use of a 2-digit year
      representation
  - ANSI C `asctime()` format

  For more info see: https://www.rfc-editor.org/rfc/rfc2616#section-3.3.1
      
  ## Returns
  When successful, an `{:ok, cookie}` tuple where `cookie` is a struct representation of the
  cookie string.

  Otherwise, returns an `{:error, atom}`, consult the types for more info.

  ## Examples

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

  Similar to `decode/1` except it will unwrap the error tuple and raise an
  `ArgumentError` in case of errors.
  """
  @spec decode!(String.t()) :: Cookie.t()
  def decode!(cookie) do
    case decode(cookie) do
      {:ok, decoded_cookie} -> decoded_cookie
      {:error, error} -> raise ArgumentError, Atom.to_string(error)
    end
  end
end
