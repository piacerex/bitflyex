defmodule Json do
	def body( %{ status_code: 200, body: body } ), do: body
end
