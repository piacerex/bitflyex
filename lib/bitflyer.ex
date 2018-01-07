defmodule BitFlyex do
	@moduledoc """
	bitFlyer Lightning API library.
	"""

	defp api_key(), do: Application.get_env( :bitflyex, :setting ) |> Poison.decode! |> Map.get( "api_key" )
	defp secret(),  do: Application.get_env( :bitflyex, :setting ) |> Poison.decode! |> Map.get( "secret" )

	defp domain(), do: "https://api.bitflyer.jp"

	@doc """
	Get timestamp (this test for balance() test. Don't remove)

	## Examples
		iex> BitFlyex.timestamp |> String.length
		22
	"""
	def timestamp(), do: Dt.now_timestamp( "-", "T", ":", "." ) |> String.slice( 0, 22 )
	defp sign( path, body \\ "" ) do
		:crypto.hmac( :sha256, secret(), timestamp() <> "GET" <> path <> body ) 
		|> Base.encode16 
		|> String.downcase 
	end

	@doc """
	Get balance from bitFlyer account

	## Examples
		iex> BitFlyex.balance
		[%{"amount" => 0.6, "available" => 0.6, "currency_code" => "BTC"},
		 %{"amount" => 1.0, "available" => 1.0, "currency_code" => "BCH"},
		 %{"amount" => 12.0, "available" => 12.0, "currency_code" => "ETH"},
		 %{"amount" => 100.0, "available" => 100.0, "currency_code" => "ETC"},
		 %{"amount" => 13.0, "available" => 13.0, "currency_code" => "LTC"},
		 %{"amount" => 300.0, "available" => 300.0, "currency_code" => "MONA"}]
	"""
	def balance(), do: Json.get( domain(), path_balance(), path_header(), &map_balance/1 )
	defp path_balance(), do: "/v1/me/getbalance"	# This path don't refactoring ('v1' use signature)
	defp path_header() do
		[ 
			"ACCESS-KEY":       "#{ api_key() }", 
			"ACCESS-TIMESTAMP": "#{ timestamp() }", 
			"ACCESS-SIGN":      "#{ sign( path_balance() ) }", 
		]
	end
	defp map_balance( map_list ) do
		map_list
		|> Enum.filter( fn %{ "currency_code" => currency_code } -> currency_code != "JPY" end )
	end

	@doc """
	Get market products from bitFlyer

	## Examples
		iex> BitFlyex.markets
		["BTC_JPY", "FX_BTC_JPY", "ETH_BTC", "BCH_BTC", "BTCJPY12JAN2018", "BTCJPY19JAN2018"]
	"""
	def markets(), do: Json.get( domain(), path_markets(), [], &map_markets/1 )
	defp path_markets(), do: "/v1/markets"	# This path don't refactoring ('v1' use signature)
	defp map_markets( map_list ) do
		map_list
		|> Enum.map( fn %{ "product_code" => product_code } -> product_code end )
	end
end
