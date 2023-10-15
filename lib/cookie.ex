defmodule CookieMonster.Cookie do
  @moduledoc """
  Data Structure for representing a cookie in Elixir
  """

  @enforce_keys [:name, :value]
  defstruct [:name, :value, :max_age, :path, :expires, :same_site, :domain, :secure, :http_only]

  @type t :: %__MODULE__{
          name: binary(),
          value: binary(),
          expires: DateTime.t() | nil,
          max_age: integer() | nil,
          same_site: :strict | :lax | :none | nil,
          domain: binary() | nil,
          path: binary() | nil,
          secure: boolean(),
          http_only: boolean()
        }
end
