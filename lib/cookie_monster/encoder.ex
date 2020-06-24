defmodule CookieMonster.Encoder do
  @moduledoc """
  Converts a cookie string from an Elixir Cookie struct into a cookie string
  which can be used in requests as the Cookie header
  """

  alias CookieMonster.Cookie

  @spec encode(Cookie.t(), keyword()) :: String.t()
  def encode(cookie, target: :request) do
    "#{cookie.name}=#{cookie.value}"
  end
end
