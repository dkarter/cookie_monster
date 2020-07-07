defmodule CookieMonster.DecoderTest do
  use ExUnit.Case, async: true

  alias CookieMonster.Cookie
  alias CookieMonster.Decoder

  describe "decode/1" do
    test "parses cookie string from Set-Cookie header" do
      cookie = "id=a3fWa; Expires=Wed, 21 Oct 2015 07:28:00 GMT; Secure; HttpOnly"

      assert {:ok, cookie} = Decoder.decode(cookie)

      assert cookie == %Cookie{
               value: "a3fWa",
               expires: ~U[2015-10-21 07:28:00Z],
               http_only: true,
               name: "id",
               secure: true
             }
    end

    test "decodes cookie with extra params in different order" do
      cookie =
        "secret=VGhhbmsgeW91IGZvciByZWFkaW5nIG15IGNvZGUhIHdhbm5hIGNoYXQ%2FIG1lQGRvcmlhbmthcnRlci5jb20gPGo%3D; SameSite=Strict; expires=Tue, 15 Jun 2021 05:32:54 GMT; path=/; secure"

      assert {:ok, cookie} = Decoder.decode(cookie)

      assert cookie == %Cookie{
               value:
                 "VGhhbmsgeW91IGZvciByZWFkaW5nIG15IGNvZGUhIHdhbm5hIGNoYXQ%2FIG1lQGRvcmlhbmthcnRlci5jb20gPGo%3D",
               expires: ~U[2021-06-15 05:32:54Z],
               path: "/",
               http_only: nil,
               name: "secret",
               secure: true,
               same_site: :strict
             }
    end

    test "parses cookie string with mixed / no spaces" do
      cookie = "CNAME=chocolate%20chip; Expires=Wed, 21 Oct 2015 07:28:00 GMT;Secure;HttpOnly"

      assert {:ok, cookie} = Decoder.decode(cookie)

      assert cookie == %Cookie{
               value: "chocolate%20chip",
               expires: ~U[2015-10-21 07:28:00Z],
               http_only: true,
               name: "CNAME",
               secure: true
             }
    end

    test "returns an error if invalid cookie was provided" do
      assert {:error, :invalid_cookie} = Decoder.decode("")
    end
  end
end
