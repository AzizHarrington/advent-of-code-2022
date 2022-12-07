defmodule Problems.Solution2 do
  def run(filename) do
    load_file(filename)
    |> Stream.map(&(String.split(&1, " ")))
    |> Stream.map(fn [opponent_code, player_code] ->
      [object(opponent_code), object(player_code)]
    end)
    |> Stream.map(fn [opponent, player] ->
      object_score(player) + match_score(player, opponent)
    end)
    |> Enum.sum()
  end

  defp object(code) when code in ["A", "X"], do: :rock
  defp object(code) when code in ["B", "Y"], do: :paper
  defp object(code) when code in ["C", "Z"], do: :scissors

  defp object_score(:rock), do: 1
  defp object_score(:paper), do: 2
  defp object_score(:scissors), do: 3

  defp match_score(:rock, :scissors), do: 6
  defp match_score(:paper, :rock), do: 6
  defp match_score(:scissors, :paper), do: 6
  defp match_score(:scissors, :rock), do: 0
  defp match_score(:rock, :paper), do: 0
  defp match_score(:paper, :scissors), do: 0
  defp match_score(object, object), do: 3

  defp load_file(filename) do
    File.read!(filename)
    |> String.split("\n")
  end
end
