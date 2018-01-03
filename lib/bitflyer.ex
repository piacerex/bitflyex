defmodule BitFlyer do
	@moduledoc """
	Documentation for BitFlyer.
	"""

	def api_key(), do: ""
	def secret(),  do: ""

	def domain(), do: "https://api.bitflyer.jp"

	@doc """
	Get timestamp for bitFlyer

	## Examples
		iex> BitFlyer.timestamp |> String.length
		22
	"""
	def timestamp(), do: Dt.now_timestamp( "-", "T", ":", "." ) |> String.slice( 0, 22 )
	def sign( path, body \\ "" ) do
		:crypto.hmac( :sha256, secret(), timestamp() <> "GET" <> path <> body ) 
		|> Base.encode16 
		|> String.downcase 
	end

	@doc """
	Get balance from bitFlyer account

	## Examples
		iex> BitFlyer.balance
		[%{"amount" => 0.6, "available" => 0.6, "currency_code" => "BTC"},
		 %{"amount" => 1.0, "available" => 1.0, "currency_code" => "BCH"},
		 %{"amount" => 12.0, "available" => 12.0, "currency_code" => "ETH"},
		 %{"amount" => 100.0, "available" => 100.0, "currency_code" => "ETC"},
		 %{"amount" => 13.0, "available" => 13.0, "currency_code" => "LTC"},
		 %{"amount" => 300.0, "available" => 300.0, "currency_code" => "MONA"}]
	"""
	def balance(), do: Json.call( domain(), path_balance(), path_header(), &map_balance/1 )
	def path_balance(), do: "/v1/me/getbalance"
	def path_header() do
		[ 
			"ACCESS-KEY":       "#{ api_key() }", 
			"ACCESS-TIMESTAMP": "#{ timestamp() }", 
			"ACCESS-SIGN":      "#{ sign( path_balance() ) }", 
		]
	end
	def map_balance( map_list ) do
		map_list
		|> Enum.filter( fn %{ "currency_code" => currency_code } -> currency_code != "JPY" end )
	end

	@doc """
	Get market products from bitFlyer

	## Examples
		iex> BitFlyer.markets
		["BTC_JPY", "FX_BTC_JPY", "ETH_BTC", "BCH_BTC", "BTCJPY05JAN2018", "BTCJPY12JAN2018"]
	"""
	def markets(), do: Json.call( domain(), path_markets(), [], &map_markets/1 )
	def path_markets(), do: "/v1/markets"
	def map_markets( map_list ) do
		map_list
		|> Enum.map( fn %{ "product_code" => product_code } -> product_code end )
	end
end
