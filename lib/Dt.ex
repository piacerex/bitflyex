defmodule Dt do
	def now_timestamp( date_sep \\ "", separate \\ "", time_sep \\ "", second_sep \\ "" ) do
		Timex.now |> to_timestamp_string( date_sep, separate, time_sep, second_sep )
	end
	def to_timestamp_string( dt, date_sep \\ "", between_sep \\ "", time_sep \\ "", second_sep \\ "" ) do
		ss = dt |> format( "{ss}" ) |> String.replace( ".", second_sep )
		dt |> format( "{YYYY}#{ date_sep }{0M}#{ date_sep }{0D}#{ between_sep }{h24}#{ time_sep }{m}#{ time_sep }{s}#{ ss }" )
	end
	def format( dt, format_str ) do
		{ :ok, result } = Timex.format( dt, format_str )
		result
	end
end
