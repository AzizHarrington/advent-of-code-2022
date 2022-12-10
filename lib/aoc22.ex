defmodule Aoc22 do
  @moduledoc """
  Documentation for `Aoc22`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc22.hello()
      :world

  """
  def hello do
    :world
  end

  def load_file(filename) do
    File.read!(filename)
    |> String.split("\n")
  end

  def drop_last(list) do
    list |> Enum.reverse() |> tl() |> Enum.reverse()
  end
end
