defmodule CookieMonster.CookieDateTime.Parser.ASCTIMETest do
  use ExUnit.Case, async: true

  alias CookieMonster.CookieDateTime.Parser.ASCTIME

  describe "parse/1" do
    test "works for dates with double digit days" do
      input = "Sun Nov 16 08:49:37 1994"
      expected = ~U[1994-11-16 08:49:37Z]

      assert expected == ASCTIME.parse(input)
    end

    test "works for dates with single digit days" do
      input = "Sun Nov  6 08:49:37 1994"
      expected = ~U[1994-11-06 08:49:37Z]

      assert expected == ASCTIME.parse(input)
    end
  end
end
