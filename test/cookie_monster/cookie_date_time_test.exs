defmodule CookieMonster.CookieDateTimeTest do
  use ExUnit.Case, async: true

  alias CookieMonster.CookieDateTime

  describe "format/1" do
    test "returns a string representation of the datetime provided matching the cookie format" do
      assert CookieDateTime.format(~U[2015-10-21 07:28:59Z]) == "Wed, 21 Oct 2015 07:28:59 GMT"
    end
  end

  describe "parse/1" do
    test "parses datetime in cookie RFC 1123 format" do
      input = "Sun, 06 Nov 1994 08:49:37 GMT"
      expected = ~U[1994-11-06 08:49:37Z]

      assert {:ok, expected} == CookieDateTime.parse(input)
    end

    test "parses datetime in cookie RFC 850 format" do
      input = "Sunday, 06-Nov-23 08:49:37 GMT"
      expected = ~U[2023-11-06 08:49:37Z]

      assert {:ok, expected} == CookieDateTime.parse(input)
    end

    test "parses datetime in cookie RFC 850 format with short week day" do
      input = "Fri, 20-Oct-23 07:22:39 GMT"
      expected = ~U[2023-10-20 07:22:39Z]

      assert {:ok, expected} == CookieDateTime.parse(input)
    end

    test "parses datetime in cookie asctime format" do
      input = "Sun Nov  6 08:49:37 1994"
      expected = ~U[1994-11-06 08:49:37Z]

      assert {:ok, expected} == CookieDateTime.parse(input)
    end
  end
end
