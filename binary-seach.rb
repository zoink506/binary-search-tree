class Node
  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  def initialize(arr)
    arr = arr.uniq.sort
    @root = build_tree(arr, 0, arr.length - 1)
  end

  def build_tree(arr, arr_start, arr_end)
    # Returns root (first middle value)
    return if arr_start > arr_end

    middle_index = ((arr_start + arr_end) / 2)
    puts "Middle: #{middle_index}"

    return arr[middle_index]
  end
end

binary_tree = Tree.new([1, 2, 3, 4, 5, 6, 7])

# arr.length / 2
# [1, 2, 3, 4, 5, 6]               | middle = 3
# [1, 2, 3, 4, 5, 6, 7]            | middle = 3.5
# [1, 2, 3, 4, 5, 6, 7, 8]         | middle = 4
# [1, 2, 3, 4, 5, 6, 7, 8, 9]      | middle = 4.5
# [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]  | middle = 5

# ((arr.length / 2) - 1).ceil
# [1, 2, 3, 4, 5, 6]               | middle = 2
# [1, 2, 3, 4, 5, 6, 7]            | middle = 3
# [1, 2, 3, 4, 5, 6, 7, 8]         | middle = 3
# [1, 2, 3, 4, 5, 6, 7, 8, 9]      | middle = 4
