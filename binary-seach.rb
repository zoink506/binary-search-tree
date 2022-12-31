class Node
  attr_accessor :data, :left, :right
  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  attr_reader :root
  def initialize(arr)
    arr = arr.uniq.sort
    @root = build_tree(arr, 0, arr.length - 1)
  end

  def build_tree(arr, arr_start, arr_end)
    return if arr_start > arr_end
    return :empty_array if arr.length <= 0

    middle_index = ((arr_start + arr_end) / 2)
    #puts "Middle: #{arr[middle_index]}"
    #p arr[arr_start..arr_end]
    new_node = Node.new(arr[middle_index])
    #p "new_node: #{new_node.data}"

    new_node.left = build_tree( arr, arr_start, middle_index - 1 )
    new_node.right = build_tree( arr, middle_index + 1, arr_end )

    return new_node
  end

  def print_tree(node = @root, count = 0, is_left = 'root')
    if !node.nil?
      count.times { print ' ' }

      is_left == true ? prefix = '(L)' : prefix = '(R)'
      prefix = '' if is_left == 'root'

      puts "#{prefix} #{node.data}"
      print_tree(node.left, count + 1, true)
      print_tree(node.right, count + 1, false)
    end

    return
  end

  def find(target, node = @root)
    if !node.nil?
      return node if target == node.data
      
      if target > node.data
        return find(target, node.right)
      elsif target < node.data
        return find(target, node.left)
      end
    end

    :not_found
  end

  def insert(value, node = @root)
    # Always inserts as a leaf node
    return :duplicate_value if value == node.data

    if value < node.data
      if node.left.nil?
        #puts "Reached end of tree (L), #{node.data}"
        node.left = Node.new(value)
      else
        insert(value, node.left)
      end
    elsif value > node.data
      if node.right.nil?
        #puts "Reached end of tree (R), #{node.data}"
        node.right = Node.new(value)
      else
        insert(value, node.right)
      end
    end
  end

  def delete(value, node = @root)
    # Cases:
    #   - Delete a node with 0 children
    #     + Simply remove the leaf from it's root element's left or right attribute
    #   - Delete a node with 1 child
    #     + Copy the child to replace the deleted node
    #   - Delete a node with 2 children
    #     + Find smallest value in that subtree, replace with the deleted node
    #
    # Steps:
    #   - Loop recursively to find the value in question
    #   - Check if it is a leaf, one child or two children
    #   - Perform according to cases above

    

end

binary_tree = Tree.new([2, 4, 6, 8, 10, 12, 14])
binary_tree.insert(13)
binary_tree.insert(15)
binary_tree.insert(13.5)
binary_tree.print_tree
binary_tree.delete(13)
binary_tree.print_tree



#binary_tree.print_tree
#binary_tree.insert(10)

# [1, 2, 3, 4, 5, 6, 7]
# Middle: 4
# Middle: 2
# Middle: 1
# Middle: 3
# Middle: 6
# Middle: 5
# Middle: 7
