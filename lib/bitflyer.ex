defmodule BitFlyer do
	def api_key(), do: ""
	def secret(),  do: ""

	def timestamp(), do: Timex.now()
	def path(), do: "/v1/me/getbalance"
	def sign() do
		text = timestamp() <> "GET" <> path()
		:crypto.hmac( :sha256, secret(), text )
	end

	def balance() do
		"https://api.bitflyer.jp" <> path()
		|> HTTPoison.get!( [ "ACCESS-KEY": "#{ api_key() }", "ACCESS-TIMESTAMP": "#{ timestamp() }", "ACCESS-SIGN": "sign()" ] )
		|> Json.body
		|> Poison.decode!
	end
end
