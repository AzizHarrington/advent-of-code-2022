defmodule Problems.Solution7 do
  import Aoc22

  def run(filename) do
    file = load_file(filename)

    IO.inspect part1(file)
    IO.inspect part2(file)
  end

  defp part1(file) do
    file
    |> build_file_system()
    |> find_directory_sizes()
    |> Enum.map(fn {size, _ } -> size end)
    |> Enum.filter(fn size -> size <= 100_000 end)
    |> Enum.sum()
  end

  defp part2(file) do
    [ root | directories ] =
      file
        |> build_file_system()
        |> find_directory_sizes()
        |> Enum.map(fn {size, _ } -> size end)
        |> Enum.sort(:desc)

    directories
      |> Enum.filter(fn dir ->
        (70_000_000 - root + dir) > 30_000_000
      end)
      |> Enum.min()
  end

  defp find_directory_sizes(tree) do
    tree
    |> directory_sizes()
    |> Enum.map(fn {directory, size, descendent_size } ->
      {size + descendent_size, directory}
    end)
  end

  defp directory_sizes(tree) when tree == %{} do
    []
  end

  defp directory_sizes(tree) do
    tree
    |> Enum.flat_map(fn {dir, %{children: children, files: files}} ->
      descendents = directory_sizes(children)

      dir_content_size =
        files
        |> Enum.map(fn {_, size} -> size end)
        |> Enum.sum()

      dir_size = {
        dir,
        dir_content_size,
        get_descendent_size(descendents)
      }

      [dir_size | descendents]
    end)
  end

  defp get_descendent_size([]), do: 0
  defp get_descendent_size([ {_, size, _} |  descendents]) do
    size + get_descendent_size(descendents)
  end

  defp build_file_system(file) do
    commands = file |> Enum.map(&String.split/1)

    file_system = build(%{"/" => %{files: [], children: %{}}}, [], commands)

    File.open("./day7tree", [:write], fn f ->
      IO.inspect(f, file_system, [])
    end)

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
    {parsed_size, _} = Integer.parse(size)
    updated_tree = add_file(tree, Enum.reverse(path), filename, parsed_size)

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
