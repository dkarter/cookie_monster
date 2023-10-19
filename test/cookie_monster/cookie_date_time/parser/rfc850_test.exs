defmodule CookieMonster.CookieDateTime.Parser.RFC850Test do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog, only: [with_log: 2]

  alias CookieMonster.CookieDateTime.Parser.RFC850

  describe "parse/1" do
    test "parses dates with year from 32" do
      input = "Sunday, 06-Nov-32 08:49:37 GMT"
      expected = ~U[2032-11-06 08:49:37Z]

      assert expected == RFC850.parse(input)
    end

    test "parses dates with year from 32 and short weekday" do
      input = "Sun, 06-Nov-32 08:49:37 GMT"
      expected = ~U[2032-11-06 08:49:37Z]

      assert expected == RFC850.parse(input)
    end

    test "parses dates with year from 94 and receives a warning log" do
      input = "Sunday, 06-Nov-94 08:49:37 GMT"
      expected = ~U[1994-11-06 08:49:37Z]

      {parsed_date, log} =
        with_log([level: :warning], fn ->
          RFC850.parse(input)
        end)

      assert expected == parsed_date
      assert log =~ "Guessing cookie expiration year: 94 as 1994"
    end

    test "parses dates with year after 94 and receives a warning log" do
      input = "Sunday, 06-Nov-95 08:49:37 GMT"
      expected = ~U[1995-11-06 08:49:37Z]

      {parsed_date, log} =
        with_log([level: :warning], fn ->
          RFC850.parse(input)
        end)

      assert expected == parsed_date
      assert log =~ "Guessing cookie expiration year: 95 as 1995"
    end
  end
end
