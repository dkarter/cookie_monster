# CookieMonster

![Build Status](https://github.com/dkarter/cookie_monster/actions/workflows/elixir.yml/badge.svg)

A simple HTTP Cookie encoder and decoder in pure Elixir with zero runtime dependencies[^1].

![cookie monster logo](img/cookie_monster.png)

## Motivation

I recently worked on an app that needed to parse cookies. Initially I reached
out for [Plug](https://hex.pm/packages/plug)'s implementation to encode
and decode the cookies, but that meant bringing in a (relatively) large dependency just to use a small portion of it (my application was not web facing).

Another issue I had with Plug's implementation is that it used the name of the cookie as a map key in the decoding result:

```elixir
"id=a3fWa; Expires=Wed, 21 Oct 2015 07:28:00 GMT; HttpOnly; Secure"
|> Plug.Conn.Cookies.decode()

# => %{"Expires" => "Wed, 21 Oct 2015 07:28:00 GMT", "id" => "a3fWa"}
```

I wanted something a little simpler, and dependency free that makes it easy to extract the name and
value. As a bonus, I wanted to decode the date into an Elixir native DateTime
so that I can easily check if a cookie is expired.

## Example

#### Encoding

```elixir
alias CookieMonster.Cookie

%Cookie{
  name: "id",
  value: "a3fWa",
  expires: ~U[2015-10-21 07:28:00Z],
  http_only: true,
  secure: true
}
|> CookieMonster.encode!()

# => "id=a3fWa; Expires=Wed, 21 Oct 2015 07:28:00 GMT; HttpOnly; Secure"
```

#### Decoding

```elixir
alias CookieMonster.Cookie

"id=a3fWa; Expires=Wed, 21 Oct 2015 07:28:00 GMT; HttpOnly; Secure"
|> CookieMonster.decode!()

# => %Cookie{name: "id", value: "a3fWa", expires: ~U[2015-10-21 07:28:00Z], http_only: true, secure: true}
```

## Installation

The package can be installed by adding `cookie_monster` to your list of
dependencies in `mix.exs`:

<!-- x-release-please-start-version -->

```elixir
def deps do
  [
    {:cookie_monster, "~> 1.0.0"}
  ]
end
```

<!-- x-release-please-end-version -->

The docs can be found at [https://hexdocs.pm/cookie_monster](https://hexdocs.pm/cookie_monster).

[^1]: Boundary is listed as a dependency, but it is not a runtime dependency and only used during compile time to ensure proper design
