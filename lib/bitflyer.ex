defmodule BitFlyex do
	@moduledoc """
	bitFlyer Lightning API library.
	"""

	defp domain(), do: "https://api.bitflyer.jp"

	defp api_key(), do: Application.get_env( :bitflyex, :setting ) |> Poison.decode! |> Map.get( "api_key" )
	defp secret(),  do: Application.get_env( :bitflyex, :setting ) |> Poison.decode! |> Map.get( "secret" )

	defp to_side(  1 ), do: "BUY"
	defp to_side( -1 ), do: "SELL"

	def timestamp(), do: Dt.now_timestamp( "-", "T", ":", "." ) |> String.slice( 0, 22 )
	defp sign( method, path, body \\ "" ) do
		:crypto.hmac( :sha256, secret(), timestamp() <> method <> path <> body ) 
		|> Base.encode16 
		|> String.downcase 
	end

	defp private_post_header( path, body ) do
		[ 
			"ACCESS-KEY":       "#{ api_key() }", 
			"ACCESS-TIMESTAMP": "#{ timestamp() }", 
			"ACCESS-SIGN":      "#{ sign( "POST", path, body ) }", 
			"Content-type":     "application/json", 
		]
	end
	defp private_header( path ) do
		[ 
			"ACCESS-KEY":       "#{ api_key() }", 
			"ACCESS-TIMESTAMP": "#{ timestamp() }", 
			"ACCESS-SIGN":      "#{ sign( "GET", path ) }", 
			"Content-type":     "application/json", 
		]
	end

	@doc """
	List market products

	## Examples
		iex> BitFlyex.markets |> Enum.map( fn %{ "product_code" => product_code } -> product_code end )
		["BTC_JPY", "FX_BTC_JPY", "ETH_BTC", "BCH_BTC", "BTCJPY12JAN2018", "BTCJPY19JAN2018"]
	"""
	def markets(), do: Json.get( domain(), path_markets() )
	defp path_markets(), do: "/v1/markets"	# This path don't refactoring ('v1' use signature)

	@doc """
	Get board (List bids & asks)

	## Examples
		iex> BitFlyex.board |> Map.keys
		["asks", "bids", "mid_price"]
	"""
	def board( product_code \\ nil ), do: Json.get( domain(), path_board() <> params_board( product_code ), private_header( path_board() ) )
	defp path_board(), do: "/v1/board"	# This path don't refactoring ('v1' use signature)
	defp params_board( nil ), do: ""
	defp params_board( product_code ), do: "?product_code=#{product_code}"

	@doc """
	Get ticker

	## Examples
		iex> BitFlyex.ticker|> Map.keys
		["best_ask", "best_ask_size", "best_bid", "best_bid_size", "ltp","product_code", 
		 "tick_id", "timestamp", "total_ask_depth", "total_bid_depth", "volume", "volume_by_product"]
	"""
	def ticker( product_code \\ nil ), do: Json.get( domain(), path_ticker() <> params_ticker( product_code ), private_header( path_ticker() ) )
	defp path_ticker(), do: "/v1/ticker"	# This path don't refactoring ('v1' use signature)
	defp params_ticker( nil ), do: ""
	defp params_ticker( product_code ), do: "?product_code=#{product_code}"

	@doc """
	List order executions

	## Examples
		iex> BitFlyex.executions |> List.first |> Map.keys
		["buy_child_order_acceptance_id", "exec_date", "id", "price", "sell_child_order_acceptance_id", "side", "size"]
	"""
	def executions( product_code \\ nil ), do: Json.get( domain(), path_executions() <> params_executions( product_code ), private_header( path_executions() ) )
	defp path_executions(), do: "/v1/executions"	# This path don't refactoring ('v1' use signature)
	defp params_executions( nil ), do: "?count=1000"
	defp params_executions( product_code ), do: "?count=1000&product_code=#{product_code}"

	@doc """
	Get permisions

	## Examples
		iex> BitFlyex.get_permisions |> is_list
		true
	"""
	def get_permisions(), do: Json.get( domain(), path_get_permisions(), private_header( path_get_permisions() ) )
	defp path_get_permisions(), do: "/v1/me/getpermissions"	# This path don't refactoring ('v1' use signature)

	@doc """
	List account balance

	## Examples
		iex> BitFlyex.balance |> is_list
		true
	"""
	def balance(), do: Json.get( domain(), path_balance(), private_header( path_balance() ), &map_balance/1 )
	defp path_balance(), do: "/v1/me/getbalance"	# This path don't refactoring ('v1' use signature)
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
	def get_collateral(), do: Json.get( domain(), path_get_collateral(), private_header( path_get_collateral() ) )
	defp path_get_collateral(), do: "/v1/me/getcollateral"	# This path don't refactoring ('v1' use signature)

	@doc """
	Get collateral acounts

	## Examples
		iex> BitFlyex.get_collateral_accounts
		[]
	"""
	def get_collateral_accounts(), do: Json.get( domain(), path_get_collateral_accounts(), private_header( path_get_collateral_accounts() ) )
	defp path_get_collateral_accounts(), do: "/v1/me/getcollateralaccounts"	# This path don't refactoring ('v1' use signature)

	@doc """
	List bitcoin addresses

	## Examples
		iex> BitFlyex.get_addresses |> List.first |> Map.keys
		["address", "currency_code", "type"]
		iex> BitFlyex.get_addresses |> Enum.map( fn %{ "currency_code" => currency_code } -> currency_code end )
		["BTC", "BCH"]
	"""
	def get_addresses(), do: Json.get( domain(), path_get_addresses(), private_header( path_get_addresses() ) )
	defp path_get_addresses(), do: "/v1/me/getaddresses"	# This path don't refactoring ('v1' use signature)

	@doc """
	Get bitcoin ins

	## Examples
		iex> BitFlyex.get_coin_ins
		[]
	"""
	def get_coin_ins(), do: Json.get( domain(), path_get_coin_ins(), private_header( path_get_coin_ins() ) )
	defp path_get_coin_ins(), do: "/v1/me/getcoinins"	# This path don't refactoring ('v1' use signature)

	@doc """
	Get bitcoin outs

	## Examples
		iex> BitFlyex.get_coin_outs
		[]
	"""
	def get_coin_outs(), do: Json.get( domain(), path_get_coin_outs(), private_header( path_get_coin_outs() ) )
	defp path_get_coin_outs(), do: "/v1/me/getcoinouts"	# This path don't refactoring ('v1' use signature)

	@doc """
	Get bank accounts

	## Examples
		iex> BitFlyex.get_bank_accounts |> List.first |> Map.keys
		["account_name", "account_number", "account_type", "bank_name", "branch_name", "id", "is_verified"]
	"""
	def get_bank_accounts(), do: Json.get( domain(), path_get_bank_accounts(), private_header( path_get_bank_accounts() ) )
	defp path_get_bank_accounts(), do: "/v1/me/getbankaccounts"	# This path don't refactoring ('v1' use signature)

	@doc """
	List deposits

	## Examples
		iex> BitFlyex.get_deposits |> is_list
		true
	"""
	def get_deposits(), do: Json.get( domain(), path_get_deposits(), private_header( path_get_deposits() ) )
	defp path_get_deposits(), do: "/v1/me/getdeposits"	# This path don't refactoring ('v1' use signature)

	@doc """
	Withdraw to bank
#
#	## Examples
#		iex> BitFlyex.withdraw( "JPY", 139xxxxxx, 100000, "87xxx6" )
#		%{"message_id" => "2bxxxxx-exxx-4xxx-bxxx-c8xxxxxxxx"}
	"""
	def withdraw( currency_code, bank_account_id, amount, code ) do
		Json.post( domain(), path_withdraw(), params_withdraw( currency_code, bank_account_id, amount, code ), 
			private_post_header( path_withdraw(), params_withdraw( currency_code, bank_account_id, amount, code ) ) )
	end
	defp path_withdraw(), do: "/v1/me/withdraw"	# This path don't refactoring ('v1' use signature)
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
	def get_withdrawals(), do: Json.get( domain(), path_get_withdrawals(), private_header( path_get_withdrawals() ) )
	defp path_get_withdrawals(), do: "/v1/me/getwithdrawals"	# This path don't refactoring ('v1' use signature)

#	@doc """
#	Get trading commission
#
#	## Examples
#		iex> BitFlyex.get_trading_commission |> Map.keys
#		["buy_child_order_acceptance_id", "exec_date", "id", "price", "sell_child_order_acceptance_id", "side", "size"]
#	"""
#	def get_trading_commission( product_code ), do: Json.get( domain(), path_get_trading_commission() <> params_get_trading_commission( product_code ), private_header( path_get_trading_commission() ) )
#	defp path_get_trading_commission(), do: "/v1/me/gettradingcommission"	# This path don't refactoring ('v1' use signature)
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
		params = params_send_child_order( product_code, "MARKET", to_side( signal ), 0, position_size, 43200, "GTC" )
		Json.post( domain(), path_send_child_order(), params,  private_post_header( path_send_child_order(), params ) )
	end
	defp path_send_child_order(), do: "/v1/me/sendchildorder"	# This path don't refactoring ('v1' use signature)
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
