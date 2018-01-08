# Bitflyex

[Bitflyex](https://hex.pm/packages/bitflyex) is a bitFlyer Lightning API library in Elixir. Here is an example:

```elixir
iex> BitFlyex.markets
[%{"product_code" => "BTC_JPY"}, %{"product_code" => "FX_BTC_JPY"},
 %{"product_code" => "ETH_BTC"}, %{"product_code" => "BCH_BTC"},
 %{"alias" => "BTCJPY_MAT1WK", "product_code" => "BTCJPY12JAN2018"},
 %{"alias" => "BTCJPY_MAT2WK", "product_code" => "BTCJPY19JAN2018"}]

iex> BitFlyex.board
%{"asks" => [%{"price" => 1.895e6, "size" => 0.01},
   %{"price" => 1895191.0, "size" => 0.01},
   %{"price" => 1895360.0, "size" => 0.00209619},
   %{"price" => 1896045.0, "size" => 0.21},
...
  "bids" => [%{"price" => 1894543.0, "size" => 1.494024},
   %{"price" => 1894360.0, "size" => 0.013},
   %{"price" => 1894282.0, "size" => 0.07},
   %{"price" => 1894256.0, "size" => 0.51369954},
   ...], "mid_price" => 1894771.0}

iex> BitFlyex.ticker
%{"best_ask" => 1896998.0, "best_ask_size" => 1.84539493,
  "best_bid" => 1896804.0, "best_bid_size" => 0.00209459, "ltp" => 1896838.0,
  "product_code" => "BTC_JPY", "tick_id" => 161673,
  "timestamp" => "2018-01-08T13:04:27.457", "total_ask_depth" => 2077.97577794,
  "total_bid_depth" => 2557.13394036, "volume" => 93411.14868695,
  "volume_by_product" => 8064.9809659}

iex> BitFlyex.order_market( "BTC_JPY", 1, 0.1 ) # Market Buy (2nd param equals 1 means Buy)
%{"child_order_acceptance_id" => "JRF20180108-125220-041773"}

iex> BitFlyex.order_market( "BTC_JPY", -1, 0.1 ) # Market Sell (2nd param equals -1 means Sell)
%{"child_order_acceptance_id" => "JRF20180108-125324-357807"}

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
    { :bitflyex, "~> 0.1.0" }
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

5. Input following, It's success when listed bitFlyer market products.

```
mix desp.get
iex -S mix
iex> BitFlyex.markets
[%{"product_code" => "BTC_JPY"}, %{"product_code" => "FX_BTC_JPY"},
 %{"product_code" => "ETH_BTC"}, %{"product_code" => "BCH_BTC"},
 %{"alias" => "BTCJPY_MAT1WK", "product_code" => "BTCJPY12JAN2018"},
 %{"alias" => "BTCJPY_MAT2WK", "product_code" => "BTCJPY19JAN2018"}]
```

## License
This project is licensed under the terms of the Apache 2.0 license, see LICENSE.
