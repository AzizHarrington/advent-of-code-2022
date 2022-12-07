defmodule Problems.Solution2 do
  import Aoc22
  def run(filename) do
    load_file(filename)
    |> Stream.map(&(String.split(&1, " ")))
    |> Stream.map(fn [opponent_code, outcome_code] ->
      [object(opponent_code), outcome(outcome_code)]
    end)
    |> Stream.map(fn [opponent, outcome] ->
      player = object_for_outcome(opponent, outcome)
      object_score(player) + match_score(outcome)
    end)
    |> Enum.sum()
  end

  defp object("A"), do: :rock
  defp object("B"), do: :paper
  defp object("C"), do: :scissors

  defp outcome("X"), do: :lose
  defp outcome("Y"), do: :draw
  defp outcome("Z"), do: :win

  defp object_for_outcome(:rock, :lose), do: :scissors
  defp object_for_outcome(:rock, :draw), do: :rock
  defp object_for_outcome(:rock, :win), do: :paper

  defp object_for_outcome(:paper, :lose), do: :rock
  defp object_for_outcome(:paper, :draw), do: :paper
  defp object_for_outcome(:paper, :win), do: :scissors

  defp object_for_outcome(:scissors, :lose), do: :paper
  defp object_for_outcome(:scissors, :draw), do: :scissors
  defp object_for_outcome(:scissors, :win), do: :rock

  defp object_score(:rock), do: 1
  defp object_score(:paper), do: 2
  defp object_score(:scissors), do: 3

  defp match_score(:win), do: 6
  defp match_score(:draw), do: 3
  defp match_score(:lose), do: 0
end
