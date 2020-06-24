defmodule CookieMonster.EncoderTest do
  use ExUnit.Case

  alias CookieMonster.Encoder

  doctest Encoder

  @default_cookie %{
    value: "a3fWa",
    # This should be an Elixir date
    expires: "Wed, 21 Oct 2015 07:28:00 GMT",
    http_only: true,
    name: "id",
    secure: true,
    same_site: :strict
  }

  describe "encode/1" do
    test "stringifies the cookie to be used in a request" do
      assert Encoder.encode(@default_cookie, target: :request) == "id=a3fWa"
    end
  end
end
