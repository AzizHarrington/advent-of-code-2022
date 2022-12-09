defmodule Problems.Solution5 do
  import Aoc22

  def run(filename) do
    file = load_file(filename)

    IO.inspect part1(file)
    IO.inspect part2(file)
  end

  defp part1(file) do
    {raw_stacks, [_ | raw_procedures]} =
      file
      |> Enum.split_while(fn l -> l != "" end)

    stacks = parse_stacks(raw_stacks)
    procedures = parse_procedures(raw_procedures)

    mover_9000(procedures, stacks)
  end

  defp part2(file) do
    {raw_stacks, [_ | raw_procedures]} =
      file
      |> Enum.split_while(fn l -> l != "" end)

    stacks = parse_stacks(raw_stacks)
    procedures = parse_procedures(raw_procedures)

    mover_9001(procedures, stacks)
  end

  defp mover_9000([], stacks), do: stacks
  defp mover_9000([ {num, from, to} | procs ], stacks) do
    {parsed_num, _} = Integer.parse(num)

    updated_stacks =
      1..parsed_num |> Enum.reduce(stacks, fn _, acc ->
        move_one(from, to, acc)
      end)

    mover_9000(procs, updated_stacks)
  end

  defp move_one(from, to, stacks) do
    [ crate | from_stack ] = Map.get(stacks, from)
    to_stack = Map.get(stacks, to)

    from_updated = Map.put(stacks, from, from_stack)
    Map.put(from_updated, to, [ crate | to_stack ])
  end

  defp mover_9001([], stacks), do: stacks
  defp mover_9001([ {num, from, to} | procs ], stacks) do
    {parsed_num, _} = Integer.parse(num)

    updated_stacks = move_all(parsed_num, from, to, stacks)

    mover_9001(procs, updated_stacks)
  end

  defp move_all(num, from, to, stacks) do
    from_stack = Map.get(stacks, from)
    to_stack = Map.get(stacks, to)

    from_updated = Map.put(stacks, from, Enum.drop(from_stack, num))
    Map.put(from_updated, to,  Enum.take(from_stack, num) ++ to_stack )
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
