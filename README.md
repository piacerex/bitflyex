# Bitflyex

[Bitflyex](https://hex.pm/packages/bitflyex) is a bitFlyer Lightning API library in Elixir. Here is an example:

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

1. Add to your ```mix.exs``` file:

```elixir
def deps do
  [
    { :bitflyex, "~> 0.0.7" }
  ]
end
```

2.Register API token at [bitFlyer developer](https://lightning.bitflyer.jp/developer).

3.Add ```config/bitflyex.json``` and edit from registered bitFlyer API token. Here is an example:

```
{
  "api_key": "2VBxxxxxxxxxxxvXa",
  "secret":  "oBXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXyodR4=",
}

```

4. Add to your ```config.exs``` file:

```elixir
config :bitflyex, 
  setting: "./config/bitflyex.json" |> File.read!
```

5. Input following, It's success when listed bitFlyer balance.

```
mix desp.get
iex -S mix
iex> BitFlyex.balance
[%{"amount" => 0.6, "available" => 0.6, "currency_code" => "BTC"},
 %{"amount" => 1.0, "available" => 1.0, "currency_code" => "BCH"},
 %{"amount" => 12.0, "available" => 12.0, "currency_code" => "ETH"},
...
```

## License
This project is licensed under the terms of the Apache 2.0 license, see LICENSE.
