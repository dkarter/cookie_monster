defmodule CookieMonster.EncoderTest do
  use ExUnit.Case

  alias CookieMonster.Cookie
  alias CookieMonster.Encoder

  doctest Encoder

  @default_cookie %Cookie{
    name: "id",
    value: "a3fWa",
    domain: "duckduckgo.com",
    path: "/",
    expires: ~U[2015-10-21 07:28:59Z],
    max_age: 9,
    http_only: true,
    secure: true,
    same_site: :strict
  }

  describe "encode/1" do
    test "encodes the cookie to be used in a request" do
      assert {:ok, "id=a3fWa"} = Encoder.encode(@default_cookie, target: :request)
    end

    test "encodes a simple map" do
      assert {:ok, "foo=bar"} = Encoder.encode(%{name: "foo", value: "bar"})
    end

    test "encodes a full cookie" do
      cookie =
        "id=a3fWa; Domain=duckduckgo.com; Expires=Wed, 21 Oct 2015 07:28:59 GMT; HttpOnly; Max-Age=9; Path=/; SameSite=Strict; Secure"

      assert {:ok, ^cookie} = Encoder.encode(@default_cookie)
    end

    test "returns an error if invalid" do
      assert {:error, :invalid_cookie} = Encoder.encode(%{})
    end
  end
end
