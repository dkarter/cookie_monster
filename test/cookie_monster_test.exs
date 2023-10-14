defmodule CookieMonsterTest do
  use ExUnit.Case
  doctest CookieMonster

  alias CookieMonster.Cookie

  describe "integration" do
    test "decodes cookie encoded by `encode`" do
      cookie = %Cookie{
        value:
          "VGhhbmsgeW91IGZvciByZWFkaW5nIG15IGNvZGUhIHdhbm5hIGNoYXQ%2FIG1lQGRvcmlhbmthcnRlci5jb20gPGo%3D",
        expires: ~U[2021-06-15 05:32:54Z],
        path: "/",
        http_only: nil,
        name: "secret",
        secure: true,
        same_site: :strict
      }

      assert cookie
             |> CookieMonster.encode!()
             |> CookieMonster.decode!() == cookie
    end
  end

  describe "encode!/1" do
    test "raises and error when cookie is invalid" do
      assert_raise ArgumentError, "invalid_cookie", fn ->
        CookieMonster.encode!(%{}) |> dbg
      end
    end
  end

  describe "decode!/1" do
    test "raises and error when cookie is invalid" do
      assert_raise ArgumentError, "invalid_cookie", fn ->
        CookieMonster.decode!("")
      end
    end
  end
end
