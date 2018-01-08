defmodule BitFlyex do
	@moduledoc """
	bitFlyer Lightning API library.
	"""

	defp domain(), do: "https://api.bitflyer.jp"

	defp api_key(), do: Application.get_env( :bitflyex, :setting ) |> Poison.decode! |> Map.get( "api_key" )
	defp secret(),  do: Application.get_env( :bitflyex, :setting ) |> Poison.decode! |> Map.get( "secret" )

	defp to_side(  1 ), do: "BUY"
	defp to_side( -1 ), do: "SELL"

	defp get_public( path, map_function \\ &nop/1 ) do
		Json.get( 
			domain(), 
			path,
			[],
			map_function )
	end
	defp get_private( path, map_function \\ &nop/1 ) do
		Json.get( 
			domain(), 
			path, 
			[ 
				"ACCESS-KEY":       "#{api_key()}", 
				"ACCESS-TIMESTAMP": "#{timestamp()}", 
				"ACCESS-SIGN":      "#{sign( "GET", path )}", 
				"Content-type":     "application/json", 
			], 
			map_function )
	end
	defp post_private( path, body, map_function \\ &nop/1 ) do
		Json.post( 
			domain(), 
			path, 
			body, 
			[ 
				"ACCESS-KEY":       "#{api_key()}", 
				"ACCESS-TIMESTAMP": "#{timestamp()}", 
				"ACCESS-SIGN":      "#{sign( "POST", path, body )}", 
				"Content-type":     "application/json", 
			], 
			map_function )
	end
	defp nop( map_list ), do: map_list

	def timestamp(), do: Dt.now_timestamp( "-", "T", ":", "." ) |> String.slice( 0, 22 )
	defp sign( method, path, body \\ "" ) do
		:crypto.hmac( :sha256, secret(), timestamp() <> method <> path <> body ) 
		|> Base.encode16 
		|> String.downcase 
	end

	@doc """
	List market products

	## Examples
		iex> BitFlyex.markets |> Enum.map( fn %{ "product_code" => product_code } -> product_code end )
		["BTC_JPY", "FX_BTC_JPY", "ETH_BTC", "BCH_BTC", "BTCJPY12JAN2018", "BTCJPY19JAN2018"]
	"""
	def markets(), do: get_public( "/v1/markets" )

	@doc """
	Get board (List bids & asks)

	## Examples
		iex> BitFlyex.board |> Map.keys
		["asks", "bids", "mid_price"]
	"""
	def board( product_code \\ nil ), do: get_public( "/v1/board" <> params_board( product_code ) )
	defp params_board( nil ), do: ""
	defp params_board( product_code ), do: "?product_code=#{product_code}"

	@doc """
	Get ticker

	## Examples
		iex> BitFlyex.ticker|> Map.keys
		["best_ask", "best_ask_size", "best_bid", "best_bid_size", "ltp","product_code", 
		 "tick_id", "timestamp", "total_ask_depth", "total_bid_depth", "volume", "volume_by_product"]
	"""
	def ticker( product_code \\ nil ), do: get_public( "/v1/ticker" <> params_ticker( product_code ) )
	defp params_ticker( nil ), do: ""
	defp params_ticker( product_code ), do: "?product_code=#{product_code}"

	@doc """
	List order executions

	## Examples
		iex> BitFlyex.executions |> List.first |> Map.keys
		["buy_child_order_acceptance_id", "exec_date", "id", "price", "sell_child_order_acceptance_id", "side", "size"]
	"""
	def executions( product_code \\ nil ), do: get_public( "/v1/executions" <> params_executions( product_code ) )
	defp params_executions( nil ), do: "?count=1000"
	defp params_executions( product_code ), do: "?count=1000&product_code=#{product_code}"

	@doc """
	Get permisions

	## Examples
		iex> BitFlyex.get_permisions |> is_list
		true
	"""
	def get_permisions(), do: get_private( "/v1/me/getpermissions" )

	@doc """
	List account balance

	## Examples
		iex> BitFlyex.balance |> is_list
		true
	"""
	def balance(), do: get_private( "/v1/me/getbalance", &map_balance/1 )
	defp map_balance( map_list ) do
		map_list
		|> Enum.filter( fn %{ "currency_code" => currency_code } -> currency_code != "JPY" end )
	end

	@doc """
	Get collateral

	## Examples
		iex> BitFlyex.get_collateral |> Map.keys
		["collateral", "keep_rate", "open_position_pnl", "require_collateral"]
	"""
	def get_collateral(), do: get_private( "/v1/me/getcollateral" )

	@doc """
	Get collateral acounts

	## Examples
		iex> BitFlyex.get_collateral_accounts
		[]
	"""
	def get_collateral_accounts(), do: get_private( "/v1/me/getcollateralaccounts" )

	@doc """
	List bitcoin addresses

	## Examples
		iex> BitFlyex.get_addresses |> List.first |> Map.keys
		["address", "currency_code", "type"]
		iex> BitFlyex.get_addresses |> Enum.map( fn %{ "currency_code" => currency_code } -> currency_code end )
		["BTC", "BCH"]
	"""
	def get_addresses(), do: get_private( "/v1/me/getaddresses" )

	@doc """
	Get bitcoin ins

	## Examples
		iex> BitFlyex.get_coin_ins
		[]
	"""
	def get_coin_ins(), do: get_private( "/v1/me/getcoinins" )

	@doc """
	Get bitcoin outs

	## Examples
		iex> BitFlyex.get_coin_outs
		[]
	"""
	def get_coin_outs(), do: get_private( "/v1/me/getcoinouts" )

	@doc """
	Get bank accounts

	## Examples
		iex> BitFlyex.get_bank_accounts |> List.first |> Map.keys
		["account_name", "account_number", "account_type", "bank_name", "branch_name", "id", "is_verified"]
	"""
	def get_bank_accounts(), do: get_private( "/v1/me/getbankaccounts" )

	@doc """
	List deposits

	## Examples
		iex> BitFlyex.get_deposits |> is_list
		true
	"""
	def get_deposits(), do: get_private( "/v1/me/getdeposits" )

	@doc """
	Withdraw to bank
#
#	## Examples
#		iex> BitFlyex.withdraw( "JPY", 139xxxxxx, 100000, "87xxx6" )
#		%{"message_id" => "2bxxxxx-exxx-4xxx-bxxx-c8xxxxxxxx"}
	"""
	def withdraw( currency_code, bank_account_id, amount, code ) do
		post_private( "/v1/me/withdraw", params_withdraw( currency_code, bank_account_id, amount, code ) )
	end
	defp params_withdraw( currency_code, bank_account_id, amount, code ) do
		"{ " <> 
			"\"currency_code\":   \"#{currency_code}\", "   <> 
			"\"bank_account_id\":   #{bank_account_id},   " <> 
			"\"amount\":            #{amount}, "            <> 
			"\"code\":            \"#{code}\""              <> 
		"}"
	end

	@doc """
	List widthdrawals

	## Examples
		iex> BitFlyex.get_withdrawals |> is_list
		true
	"""
	def get_withdrawals(), do: get_private( "/v1/me/getwithdrawals" )

#	@doc """
#	Get trading commission
#
#	## Examples
#		iex> BitFlyex.get_trading_commission |> Map.keys
#		["buy_child_order_acceptance_id", "exec_date", "id", "price", "sell_child_order_acceptance_id", "side", "size"]
#	"""
#	def get_trading_commission( product_code ), do: get_private( "/v1/me/gettradingcommission" <> params_get_trading_commission( product_code ) )
#	defp params_get_trading_commission( product_code ), do: "?product_code=#{product_code}"

	@doc """
	Order market
#
#	## Examples
#		iex> BitFlyex.order_market( "BTC_JPY", 1, 0.001 )
#		%{"child_order_acceptance_id" => "JRF20180108-125220-041773"}
#		iex> BitFlyex.order_market( "BTC_JPY", -1, 0.001 )
#		%{"child_order_acceptance_id" => "JRF20180108-125324-357807"}
	"""
	def order_market( product_code, signal, position_size ) do
		post_private( "/v1/me/sendchildorder", 
			params_send_child_order( product_code, "MARKET", to_side( signal ), 0, position_size, 43200, "GTC" ) )
	end
	defp params_send_child_order( product_code, child_order_type, side, price, size, minute_to_expire, time_in_force ) do
		"{ " <> 
			"\"product_code\":     \"#{product_code}\", "     <> 
			"\"child_order_type\": \"#{child_order_type}\", " <> 
			"\"side\":             \"#{side}\", "             <> 
			"\"price\":              #{price}, "              <> 
			"\"size\":               #{size}, "               <> 
			"\"minute_to_expire\":   #{minute_to_expire}, "   <> 
			"\"time_in_force\":    \"#{time_in_force}\""      <> 
		"}"
	end
end
