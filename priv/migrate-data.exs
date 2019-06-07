defmodule Hits.Import do
  def import_data do
    IO.puts "Hello World!"

    System.get_env("MIX_ENV")
    |> IO.inspect(label: "MIX_ENV")
    base = "logs/logs/"
    files = Path.wildcard(base <> "*.log")

    first = files |> Enum.at(0) |> IO.inspect(label: "first")


    # lines |> Enum.at(1) |> IO.inspect
    Enum.each(files, fn(file) ->
      f = String.replace(file, base)
      IO.inspect(file, label: "file")

      # {:ok, contents} = File.read(file)
      # lines = contents |> String.split("\n", trim: true)
      # Enum.each(lines, fn(line) -> IO.inspect(line, label: "line") end)
    end)

    files
    |> Enum.count
    |> IO.inspect(label: "count")
  end
end

Hits.Import.import_data()
