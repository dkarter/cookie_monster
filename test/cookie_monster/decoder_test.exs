defmodule CookieMonster.DecoderTest do
  use ExUnit.Case, async: true

  alias CookieMonster.Cookie
  alias CookieMonster.Decoder

  describe "decode/1" do
    test "parses cookie string from Set-Cookie header" do
      cookie = "id=a3fWa; Expires=Wed, 21 Oct 2015 07:28:00 GMT; Secure; HttpOnly"

      assert %Cookie{
               value: "a3fWa",
               expires: "Wed, 21 Oct 2015 07:28:00 GMT",
               http_only: true,
               name: "id",
               secure: true
             } == Decoder.decode(cookie)
    end

    test "decodes cookie with extra params in different order" do
      cookie =
        "wtbsess_data=ynVh2oxpzMIA2OKaMw7vBCBoAUS5ikzVRrohRr92sJrFWMs473%2BMgYDzHrXW6h0%2BqTYlcQeZttOJTExVx5c9%2FI8Vc%2BTKlQJmtKRISb8oa%2BvIutrMRW8vxOqFuz73nlOOxGh4bU68M%2F%2BlTjuapHujZVZb%2BCCcgItxfbCY6xcXN0eeBA%2FWgZAIH3Kwp%2F7oEtyoiweuUqmOJ05t0kqSkefrcSnb1%2BqwqZNacqng7d0kWvASiznzjZT7fClQ5A%3D%3D; SameSite=Strict; expires=Tue, 15-Jun-2021 05:32:54 GMT; path=/; secure"

      assert %Cookie{
               value:
                 "ynVh2oxpzMIA2OKaMw7vBCBoAUS5ikzVRrohRr92sJrFWMs473%2BMgYDzHrXW6h0%2BqTYlcQeZttOJTExVx5c9%2FI8Vc%2BTKlQJmtKRISb8oa%2BvIutrMRW8vxOqFuz73nlOOxGh4bU68M%2F%2BlTjuapHujZVZb%2BCCcgItxfbCY6xcXN0eeBA%2FWgZAIH3Kwp%2F7oEtyoiweuUqmOJ05t0kqSkefrcSnb1%2BqwqZNacqng7d0kWvASiznzjZT7fClQ5A%3D%3D",
               expires: "Tue, 15-Jun-2021 05:32:54 GMT",
               path: "/",
               http_only: nil,
               name: "wtbsess_data",
               secure: true,
               same_site: :strict
             } == Decoder.decode(cookie)
    end

    test "parses cookie string with mixed / no spaces" do
      cookie = "CNAME=chocolate%20chip; Expires=Wed, 21 Oct 2015 07:28:00 GMT;Secure;HttpOnly"

      assert %Cookie{
               value: "chocolate%20chip",
               expires: "Wed, 21 Oct 2015 07:28:00 GMT",
               http_only: true,
               name: "CNAME",
               secure: true
             } == Decoder.decode(cookie)
    end
  end
end
