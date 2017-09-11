defmodule Hash do
  @moduledoc """
  Returns a SHA512 transformed to Base64, remove ambiguous chars then sub-string
  """
  
  @doc """
  make/2 create a SHA512 hash from the given input and return the require length
  note: we remove "ambiguous" characters so _humans_ can type the hash without
  getting "confused" this might not be required, but is to match the original
  "Hits" implementation.
  
  ## Parameters

  - input: String the string to be hashed.
  - length: Number the length of string required
  
  Returns String hash of desired length.
  """
  def make(input, length \\ 13) do
    hash = :crypto.hash(:sha512, input) # dogma requires this extra line ... =(
    hash
      |> Base.encode64
      |> String.replace(~r/[Il0oO=\/\+]/, "", global: true)
      |> String.slice(0..length - 1) # 0 index so length needs decrement
  end
end
