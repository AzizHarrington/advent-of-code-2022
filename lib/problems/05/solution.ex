defmodule Problems.Solution5 do
  import Aoc22

  def run(filename) do
    file = load_file(filename)

    IO.inspect part1(file)
  end

  defp part1(file) do
    {raw_stacks, [_ | raw_procedures]} =
      file
      |> Enum.split_while(fn l -> l != "" end)

    stacks = parse_stacks(raw_stacks)
    procedures = parse_procedures(raw_procedures)

    apply_procedures(procedures, stacks)
  end

  defp apply_procedures([], stacks), do: stacks
  defp apply_procedures([ {num, from, to} | procs ], stacks) do
    {parsed_num, _} = Integer.parse(num)

    updated_stacks =
      1..parsed_num |> Enum.reduce(stacks, fn _, acc ->
        move(from, to, acc)
      end)

    apply_procedures(procs, updated_stacks)
  end

  defp move(from, to, stacks) do
    [ crate | from_stack ] = Map.get(stacks, from)
    to_stack = Map.get(stacks, to)

    from_updated = Map.put(stacks, from, from_stack)
    Map.put(from_updated, to, [ crate | to_stack ])
  end

  defp parse_stacks(raw_stacks) do
    raw_stacks
    |> Enum.reverse()
    |> Enum.map(&String.codepoints/1)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.reduce(%{}, fn
      [ " " | _ ], acc -> acc
      [ num | crates ], acc ->
        parsed_crates =
          crates |>
          Enum.filter(fn c -> c != " " end)
          |> Enum.reverse()

        Map.put(acc, num, parsed_crates)
    end)
  end

  defp parse_procedures(raw_procedures) do
    raw_procedures
    |> Stream.map(&String.split/1)
    |> Stream.map(fn p ->
      p
      |> Enum.drop_every(2)
      |> List.to_tuple()
    end)
    |> Enum.to_list()
  end
end
