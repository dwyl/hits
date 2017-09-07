defmodule MyMod do
  
  require Logger
  
  def json do
    json_input = "{\"key\":\"this will be a value\"}"
    IO.inspect json_input
    {:ok, list} = Poison.Parser.parse!(json_input)
    IO.puts list
  end
end

MyMod.json()
