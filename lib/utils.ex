defmodule App.Utils do
  @moduledoc """
  Time helper functions.
  """

  @doc """
  Get current time as string using Erlangs calendar module.
  """
  @spec now_to_string :: String
  def now_to_string do
    {{year, month, day}, {hour, minute, second}} = :calendar.local_time()
    "#{year}-#{month
    |> zero_pad}-#{day} #{hour
    |> zero_pad}:#{minute
    |> zero_pad}:#{second
    |> zero_pad}"
  end

  @spec zero_pad(Integer, Integer) :: String
  defp zero_pad(number, amount \\ 2) do
     number
     |> Integer.to_string
     |> String.pad_leading(amount, "0")
  end

end
