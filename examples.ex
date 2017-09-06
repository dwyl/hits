defmodule Example do
  @spec sum_times(integer) :: integer
  def sum_times(a) do
      [1, 2, 3]
      |> Enum.map(fn el -> el * a end)
      |> Enum.sum
      |> round
  end

  def cpu_burns(a, b, c) do
    x = a * 2
    y = b * 3
    z = c * 5

    x + y + z
  end
end
