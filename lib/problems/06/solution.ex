defmodule Problems.Solution6 do
  import Aoc22

  def run(filename) do
    file = load_file(filename)

    IO.inspect part1(file)
    IO.inspect part2(file)
  end

  defp part1([ datastream ]) do
    [ a, b, c | rest ] = datastream |> String.codepoints()

    find_start_of_packet(rest, {a, b, c}, 4)
  end

  defp find_start_of_packet([char | characters], {a, b, c}, position) do
    unique_chars = [char, a, b, c] |> MapSet.new()

    case MapSet.size(unique_chars) do
      4 -> position
      _ ->
        find_start_of_packet(characters, {b, c, char}, position + 1)
    end
  end

  defp part2([ datastream ]) do
    {start, rest} = datastream |> String.codepoints() |> Enum.split(14)

    find_start_of_message(start, rest, 14)
  end

  defp find_start_of_message(scan, [ next | datastream], position) do
    unique_chars = MapSet.new(scan)

    case MapSet.size(unique_chars) do
      14 -> position
      _ ->
        find_start_of_message([ next | drop_last(scan) ], datastream, position + 1)
    end
  end
end
