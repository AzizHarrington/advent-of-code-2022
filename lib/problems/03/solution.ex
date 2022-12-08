defmodule Problems.Solution3 do
  import Aoc22

  def run(filename) do
    file = load_file(filename)

    IO.puts part1(file)
    IO.puts part2(file)
  end

  def part1(file) do
    priorities = priorities()

    file
    |> Stream.map(&split_compartments/1)
    |> Stream.map(fn {a, b} -> {character_set(a), character_set(b)} end)
    |> Stream.map(fn {s1, s2} -> MapSet.intersection(s1, s2) end)
    |> Stream.map(&Enum.to_list/1)
    |> Stream.map(fn [item] -> get_priority(item, priorities) end)
    |> Enum.sum()
  end

  def part2(file) do
    priorities = priorities()

    file
    |> Stream.chunk_every(3)
    |> Stream.map(&find_intersection/1)
    |> Stream.map(&Enum.to_list/1)
    |> Stream.map(fn [item] -> get_priority(item, priorities) end)
    |> Enum.sum()
  end

  defp split_compartments(ruck_sack) do
    ruck_sack
    |> String.split_at(
      div(String.length(ruck_sack), 2)
    )
  end

  defp character_set(str) do
    str
    |> String.codepoints()
    |> MapSet.new()
  end

  defp get_priority(item, priorities) do
    Map.get(priorities, item)
  end

  defp priorities do
    lowercase = ?a..?z |> string_list()
    uppercase = ?A..?Z |> string_list()

    lowercase ++ uppercase
    |> Stream.with_index(1)
    |> Enum.reduce(%{}, fn {item, priority}, acc ->
      Map.put(acc, item, priority)
    end)
  end

  def string_list(range) do
    range |> Enum.to_list |> List.to_string |> String.codepoints
  end

  defp find_intersection(enumerables) do
    enumerables
    |> Enum.map(&character_set/1)
    |> Enum.reduce(fn e, acc ->
      MapSet.intersection(e, acc)
    end)
  end
end
