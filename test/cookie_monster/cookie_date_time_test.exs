defmodule CookieMonster.CookieDateTimeTest do
  use ExUnit.Case, async: true

  alias CookieMonster.CookieDateTime

  describe "format/1" do
    test "returns a string representation of the datetime provided matching the cookie format" do
      assert CookieDateTime.format(~U[2015-10-21 07:28:59Z]) == "Wed, 21 Oct 2015 07:28:59 GMT"
    end
  end

  describe "parse/1" do
    test "parses datetime in cookie format into Elixir DateTime" do
      assert CookieDateTime.parse("Wed, 21 Oct 2015 07:28:59 GMT") == ~U[2015-10-21 07:28:59Z]
    end
  end
end
