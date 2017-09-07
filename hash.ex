defmodule Hash do
  def make(input, length \\ 12) do
    IO.inspect input
    hash = :crypto.hash(:sha512, input) |> Base.encode64
    IO.inspect hash
    nospecial = String.replace(hash, ~r/[Il0oO=\/\+]/, "", global: true)
    IO.inspect nospecial
    sub = String.slice(nospecial, 0..length)
    IO.inspect sub
  end
end

Hash.make("3SsqzMWq")
