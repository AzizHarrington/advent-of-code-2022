defmodule Problems.Solution13Test do
  alias Problems.Solution
  use ExUnit.Case
  import Problems.Solution13

  test "list vs numbers" do
    left = [[[2,3] ,4]]
    right = [3,4,5]

    assert in_order?(left, right) == :ordered
  end

  test "list vs numbers 2" do
    left = [[[2,[3,[2]]],2],4,5,[[[]]]]
    right = [[3,[[4,1]]],4,6, [[],[],[]]]

    assert in_order?(left, right) == :ordered
  end

  test "list vs numbers 3" do
    left = [[[2,3] ,4]]
    right = [3, [4,5]]

    assert in_order?(left, right) == :ordered
  end

  test "two flat lists in order" do
    left = [1,1,3,1,1]
    right = [1,1,5,1,1]

    assert in_order?(left, right) == :ordered
  end

  test "mismatched list and number" do
    left = [[1],[2,3,4]]
    right = [[1],4]

    assert in_order?(left, right) == :ordered
  end


  test "left has 1 number" do
    left = [9]
    right = [[8,7,6]]

    assert in_order?(left, right) == :unordered
  end

  test "lists with same numbers" do
    left = [[4,4],4,4]
    right = [[4,4],4,4,4]

    assert in_order?(left, right) == :ordered
  end

  test "left larger than right" do
    left = [7,7,7,7]
    right = [7,7,7]

    assert in_order?(left, right) == :unordered
  end

  test "empty left" do
    left = []
    right = [3]

    assert in_order?(left, right) == :ordered
  end

  test "smaller right" do
    left = [[[]]]
    right = [[]]

    assert in_order?(left, right) == :unordered
  end

  test "multiple nesting" do
    left = [1,[2,[3,[4,[5,6,7]]]],8,9]
    right = [1,[2,[3,[4,[5,6,0]]]],8,9]

    assert in_order?(left, right) == :unordered
  end

  test "nest left list vs right number" do
    left = [[1, [4]],[2,3,4]]
    right = [[1, 2],4]

    assert in_order?(left, right) == :unordered
  end
end
