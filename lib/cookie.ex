defmodule CookieMonster.Cookie do
  @moduledoc """
  Data Structure for representing a cookie in Elixir
  """

  @enforce_keys [:name, :value]
  defstruct [:name, :value, :path, :expires, :same_site, :domain, :secure, :http_only]

  @type t :: %__MODULE__{
          name: String.t(),
          value: String.t(),
          expires: DateTime.t(),
          same_site: :strict | :lax | :none,
          domain: String.t(),
          path: String.t(),
          secure: boolean(),
          http_only: boolean()
        }
end
