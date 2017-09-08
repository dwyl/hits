defmodule Hash do
  def make(input, length \\ 13) do
    :crypto.hash(:sha512, input) 
      |> Base.encode64
      |> String.replace(~r/[Il0oO=\/\+]/, "", global: true)
      |> String.slice(0..length - 1) # 0 index so length needs decrement
  end
end
