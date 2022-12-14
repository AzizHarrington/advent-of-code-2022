defmodule Problems.Solution13 do
  import Aoc22

  def run(filename) do
    file = load_file(filename)

    IO.inspect part1(file)
  end

  defp part1(file) do
    packet_pairs = get_packet_pairs(file)

    IO.inspect packet_pairs

    analyze(packet_pairs, [])
    |> Stream.filter(fn {ordered?, _} -> ordered? == :ordered end)
    |> Stream.map(fn {_, idx} -> idx end)
    # |> Enum.to_list()
    |> Enum.sum()
  end

  defp analyze([], results), do: results

  defp analyze([ { [a, b], idx } | packets ], results) do
    IO.inspect([a, b, idx])
    result = in_order?(a, b)

    analyze(packets, [ { result, idx }  | results ])
  end

  def in_order?(left, right, recheck \\ false)
  def in_order?([], [], _) do
    IO.inspect([:two_empty_lists])
    :ordered
  end

  def in_order?([], right, _) do
    IO.inspect([:left_empty_list, right])
    :ordered
  end

  def in_order?(left, [], _) do
    IO.inspect([:right_empty_list, left])
    :unordered
  end

  def in_order?([ left | a ], [ right | b ], _) when is_list(right) and is_list(left) do
    IO.inspect([:two_lists, left: left, right: right, a: a, b: b])

    case in_order?(left, right) do
      :ordered -> :ordered
      :unordered -> :unordered
      :continue -> in_order?(a, b)
    end
  end

  def in_order?([ left | a ], [ right | b ], recheck) when is_list(left) do
    IO.inspect([:left_list, left: left, right: right, a: a, b: b])

    if recheck do
      IO.inspect(:recheck)
      in_order?(left, [right], true)
    else
      case in_order?(left, [right]) do
        :ordered -> :ordered
        :unordered -> :unordered
        :continue -> in_order?(a, b)
      end
    end
  end

  def in_order?([ left | a ], [ right | b ], recheck) when is_list(right) do
    IO.inspect([:right_list, left: left, right: right, a: a, b: b])

    if recheck do
      IO.inspect(:recheck)
      in_order?([left], right, true)
    else
      case in_order?([left], right) do
        :ordered -> :ordered
        :unordered -> :unordered
        :continue -> in_order?(a, b)
      end
    end
  end

  def in_order?(left, right, _) when is_number(left) and is_number(right) and left < right do
    :ordered
  end

  def in_order?(left, right, _) when is_number(left) and is_number(right) and left > right do
    :unordered
  end

  def in_order?(left, right, _) when is_number(left) and is_number(right) and left == right do
    :continue
  end

  def in_order?([ left | a ], [ right | b ], recheck) do
    IO.inspect([:no_lists, left: left, right: right, a: a, b: b])

    if recheck do
      IO.inspect(:recheck)
      in_order?(left, right)
    else
      case in_order?(left, right) do
        :ordered -> :ordered
        :unordered -> :unordered
        :continue -> in_order?(a,b)
      end
    end
  end

  defp get_packet_pairs(file) do
    file
    |> Stream.reject(&(&1 == ""))
    # |> Stream.map(fn packet -> String.replace(packet, ~r/[^0-9[],]/, "") end)
    |> Stream.map(fn packet ->
      {parsed, _} = Code.eval_string(packet)
      parsed
    end)
    |> Stream.chunk_every(2)
    |> Stream.with_index(1)
    |> Enum.to_list()
  end

end
