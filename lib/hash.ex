defmodule Hash do
  @moduledoc """
  Returns a SHA512 transformed to Base64, remove ambiguous chars then sub-string
  """
  def make(input, length \\ 13) do
    hash = :crypto.hash(:sha512, input) # dogma requires this extra line ... =(
    hash
      |> Base.encode64
      |> String.replace(~r/[Il0oO=\/\+]/, "", global: true)
      |> String.slice(0..length - 1) # 0 index so length needs decrement
  end
end
