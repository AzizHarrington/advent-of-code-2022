defmodule Problems.Solution7 do
  import Aoc22

  def run(filename) do
    file = load_file(filename)

    IO.inspect part1(file)
  end

  defp part1(file) do
    commands = file |> Enum.map(&String.split/1)


    file_system = build(%{"/" => %{files: [], children: %{}}}, [], commands)

    file_system
  end

  defp build(tree, _, []), do: tree

  defp build(tree, [ _ | path ], [["$", "cd", ".."] | commands]) do
    build(tree, path, commands)
  end

  defp build(tree, path, [["$", "cd", dir] | commands]) do
    build(tree, [ dir | path ], commands)
  end

  defp build(tree, path, [["$", "ls"] | commands]) do
    build(tree, path, commands)
  end

  defp build(tree, path, [["dir", dir] | commands]) do
    updated_tree = add_dir(tree, Enum.reverse(path), dir)

    build(updated_tree, path, commands)
  end

  defp build(tree, path, [[size, filename] | commands]) do
    updated_tree = add_file(tree, Enum.reverse(path), filename, size)

    build(updated_tree, path, commands)
  end

  defp add_dir(tree, [node | []], dir) do
    parent = Map.get(tree, node)
    children = Map.get(parent, :children)
    updated_children = Map.put(children, dir, %{files: [], children: %{}})
    updated_parent = Map.put(parent, :children, updated_children)

    Map.put(tree, node, updated_parent)
  end

  defp add_dir(tree, [node | path], dir) do
    parent = Map.get(tree, node)
    children = Map.get(parent, :children)
    updated_children = add_dir(children, path, dir)
    updated_parent = Map.put(parent, :children, updated_children)

    Map.put(tree, node, updated_parent)
  end

  defp add_file(tree, [node | []], filename, size) do
    parent = Map.get(tree, node)
    files = Map.get(parent, :files)
    updated_parent = Map.put(parent, :files, [ { filename, size } | files ])

    Map.put(tree, node, updated_parent)
  end

  defp add_file(tree, [node | path], filename, size) do
    parent = Map.get(tree, node)
    children = Map.get(parent, :children)
    updated_children = add_file(children, path, filename, size)
    updated_parent = Map.put(parent, :children, updated_children)

    Map.put(tree, node, updated_parent)
  end
end
