defmodule CookieMonsterTest do
  use ExUnit.Case
  doctest CookieMonster

  test "greets the world" do
    assert CookieMonster.hello() == :world
  end
end
