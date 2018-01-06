# Bitflyex

[Bitflyex](https://hex.pm/packages/bitflyex) is a bitFlyer Lightning API libraries in Elixir. Here is an example:

```elixir
iex> BitFlyex.markets
["BTC_JPY", "FX_BTC_JPY", "ETH_BTC", "BCH_BTC", "BTCJPY05JAN2018",
 "BTCJPY12JAN2018"]

iex> BitFlyex.balance
[%{"amount" => 0.6, "available" => 0.6, "currency_code" => "BTC"},
 %{"amount" => 1.0, "available" => 1.0, "currency_code" => "BCH"},
 %{"amount" => 12.0, "available" => 12.0, "currency_code" => "ETH"},
 %{"amount" => 100.0, "available" => 100.0, "currency_code" => "ETC"},
 %{"amount" => 13.0, "available" => 13.0, "currency_code" => "LTC"},
 %{"amount" => 300.0, "available" => 300.0, "currency_code" => "MONA"}]
```

See the [online documentation](https://hexdocs.pm/bitflyex).

## Installation

Add to your ```mix.exs``` file:

```elixir
def deps do
  [
    { :bitflyex, "~> 0.0.5" }
  ]
end
```

## License
This project is licensed under the terms of the Apache 2.0 license, see LICENSE.
