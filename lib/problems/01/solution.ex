defmodule Problems.Solution1 do
  def run(filename) do
    File.read!(filename)
    |> String.split("\n")
    |> Stream.chunk_while([], &chunk_fun/2, &after_fun/1)
    |> Stream.map(&parse_integer_string_list/1)
    |> Stream.map(&Enum.sum/1)
    |> Enum.to_list()
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.sum()
  end

  defp chunk_fun("", acc), do: {:cont, Enum.reverse(acc), []}
  defp chunk_fun(element, acc), do: {:cont, [element | acc]}

  defp after_fun([]), do: {:cont, []}
  defp after_fun(acc), do: {:cont, Enum.reverse(acc), []}

  defp parse_integer_string_list(list) do
    list
    |> Enum.map(fn integer_string ->
      {result, _} = Integer.parse(integer_string)
      result
    end)
  end
end
