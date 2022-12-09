defmodule Problems.Solution4 do
  import Aoc22

  def run(filename) do
    file = load_file(filename)

    IO.inspect part1(file)
    IO.inspect part2(file)
  end

  def part1(file) do
    file
    |> Stream.map(fn pair -> String.split(pair, ",") end)
    |> Stream.map(fn pair ->
      pair
      |> Enum.map(&convert_to_tuple/1)
      |> Enum.sort(fn {a_lower, a_upper}, {b_lower, b_upper} ->
        a_lower < b_lower || b_upper < a_upper
      end)
    end)
    |> Stream.map(&full_overlap/1)
    |> Enum.to_list()
    |> Enum.filter(&(&1 == true))
    |> Enum.count()
  end

  def part2(file) do
    file
    |> Stream.map(fn pair -> String.split(pair, ",") end)
    |> Stream.map(fn pair ->
      pair
      |> Enum.map(&convert_to_tuple/1)
      |> Enum.sort()
    end)
    |> Stream.map(&partial_overlap/1)
    |> Enum.filter(&(&1 == true))
    |> Enum.count()
  end

  defp convert_to_tuple(str_range) do
    [a, b] = String.split(str_range, "-")

    {lower, _} = Integer.parse(a)
    {upper, _} = Integer.parse(b)

    {lower, upper}
  end

  defp full_overlap([{a_lower, a_upper}, {b_lower, b_upper}]) do
    a_lower <= b_lower && b_upper <= a_upper
  end

  defp partial_overlap([{a_lower, a_upper}, {b_lower, _}]) do
    a_lower <= b_lower && b_lower <= a_upper
  end
end
