defmodule Problems.Solution8 do
  import Aoc22

  def run(filename) do
    file = load_file(filename)

    IO.inspect part1(file)
    IO.inspect part2(file)
  end

  defp part1(file) do
    height = Enum.count(file)
    width = file
      |> List.first()
      |> String.codepoints()
      |> Enum.count()

    grid = build_grid(file)

    grid
    |> Enum.filter(fn {idx, i} ->
      is_visible(idx, i, grid, height, width)
    end)
    |> Enum.count()
  end

  defp part2(file) do
    height = Enum.count(file)
    width = file
      |> List.first()
      |> String.codepoints()
      |> Enum.count()

    grid = build_grid(file)

    grid
    |> Enum.map(fn {idx, i} ->
      num_visible(idx, i, grid, height, width)
    end)
    |> Enum.max()
  end

  def is_visible(idx, i, grid, height, width) do
    clear_above(idx, i, grid, height)
    or clear_below(idx, i, grid, height, width)
    or clear_to_left(idx, i, grid, width)
    or clear_to_right(idx, i, grid, width)
  end

  defp clear_above(idx, i, grid, height) do
    case idx do
      0 ->
        true
      idx ->
        idx..0
        |> Enum.filter(fn n ->
          idx - n > 0
          && rem(idx - n, height) == 0
        end)
        |> Enum.map(fn above_idx ->
          i > Map.get(grid, above_idx)
        end)
        |> Enum.all?()
    end
  end

  defp clear_below(idx, i, grid, height, width) do
    ((height * width) - 1)..idx
    |> Enum.filter(fn n ->
      n - idx > 0
      && rem(idx - n, height) == 0
    end)
    |> Enum.map(fn below_idx ->
      i > Map.get(grid, below_idx)
    end)
    |> Enum.all?()
  end

  defp clear_to_left(idx, i, grid, width) do
    case rem(idx, width) do
      0 ->
        true
      pos ->
        pos..1
        |> Enum.map(fn n ->
          i > Map.get(grid, idx - n)
        end)
        |> Enum.all?()
    end
  end

  defp clear_to_right(idx, i, grid, width) do
    case (width - 1) - rem(idx, width) do
      0 ->
        true
      pos ->
        1..pos
        |> Enum.map(fn n ->
          i > Map.get(grid, idx + n)
        end)
        |> Enum.all?()
    end
  end

  def num_visible(idx, i, grid, height, width) do
    r = [
      num_visible_above(idx, i, grid, height),
      num_visible_below(idx, i, grid, height, width),
      num_visible_left(idx, i, grid, width),
      num_visible_right(idx, i, grid, width)
    ]

    Enum.product(r)
  end

  defp num_visible_above(idx, i, grid, height) do
    case idx do
      0 ->
        0
      idx ->
        idx..0
        |> Enum.filter(fn n ->
          idx - n > 0
          && rem(idx - n, height) == 0
        end)
        |> Enum.reduce_while(0, fn n, acc ->
          value = Map.get(grid, n)
          case i > value do
            false -> {:halt, acc + 1 }
            true -> {:cont, acc + 1}
          end
        end)
    end
  end

  defp num_visible_below(idx, i, grid, height, width) do
    idx..((height * width) - 1)
    |> Enum.filter(fn n ->
      n - idx > 0
      && rem(idx - n, height) == 0
    end)
    |> Enum.reduce_while(0, fn n, acc ->
      value = Map.get(grid, n)
      case i > value do
        false -> {:halt, acc + 1 }
        true -> {:cont, acc + 1}
      end
    end)
  end

  defp num_visible_left(idx, i, grid, width) do
    case rem(idx, width) do
      0 ->
        0
      pos ->
        1..pos
        |> Enum.reduce_while(0, fn n, acc ->
          value = Map.get(grid, idx - n)
          case i > value do
            false -> {:halt, acc + 1 }
            true -> {:cont, acc + 1}
          end
        end)
    end
  end

  defp num_visible_right(idx, i, grid, width) do
    case (width - 1) - rem(idx, width) do
      0 ->
        0
      pos ->
        1..pos
        |> Enum.reduce_while(0, fn n, acc ->
          value = Map.get(grid, idx + n)
          case i > value do
            false -> {:halt, acc + 1 }
            true -> {:cont, acc + 1}
          end
        end)
    end
  end

  defp build_grid(file) do
    file
      |> Enum.map(&String.codepoints/1)
      |> List.flatten()
      |> Enum.map(fn i ->
        {parsed, _} = Integer.parse(i)
        parsed
      end)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {i, idx}, acc ->
        Map.put(acc, idx, i)
      end)
  end
end
