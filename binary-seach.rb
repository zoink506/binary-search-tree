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

    if !node.nil?
      if node.data == value
        puts "Node is equal to: #{value}"

        # Check how many children
        if node.left.nil? && node.right.nil?
          # no children
          puts "#{node.data} has no children"
          return 0

        elsif !node.left.nil? && !node.right.nil?
          # 2 children
          puts "#{node.data} has 2 children"
          return 2

        elsif node.left.nil? || node.right.nil?
          # 1 child
          puts "#{node.data} has 1 child"
          return 1

        end

        return nil
      else
        #puts node.data

        if value < node.data
          # LEFT NODE
          left_node = delete(value, node.left) if !node.left.nil?
          p "left_node: #{left_node}, current_node: #{node.data}"

          if !left_node.nil?
            # If not nil, then the left node is either 0, 1, or 2.
            # It will only be 0, 1, or 2 if the left node is the value the user wants to delete

            if left_node == 0
              node.left = nil

            elsif left_node == 1
              #node.left = node.left.right
              if node.right.left.nil? # if there is no left node in the left subtree, then the 1 child is in the right node in the subtree
                node.right = node.left.right
              elsif node.right.right.nil? # likewise, but left instead of right
                node.left = node.left.left
              end

            elsif left_node == 2
              # find node that is the next largest node other the deleted node
              # go to the right subtree, then keep following the left subtrees until no left subtree is found
              # replace the deleted node's value with the next largest node's value
              
            end

          end

          nil
        elsif value > node.data
          # RIGHT NODE
          right_node = delete(value, node.right) if !node.right.nil?
          p "right_node: #{right_node}, current_node: #{node.data}"

          if !right_node.nil?
            if right_node == 0
              node.right = nil

            elsif right_node == 1
              #node.right = node.right.right
              if node.right.left.nil? # if there is no left node in the right subtree, then the 1 child is in the right node in the subtree
                node.right = node.right.right
              elsif node.right.right.nil? # likewise, but left instead of right
                node.left = node.right.left
              end

            elsif right_node == 2

            end
          end

          nil
        end
      end
    end
  end

  def find_largest_node(comparison_node, node)
    # ...
  end
end

binary_tree = Tree.new([1, 2, 3, 4, 5, 6, 7])
binary_tree.insert(9)
binary_tree.insert(10)
binary_tree.print_tree
binary_tree.delete(7)
binary_tree.print_tree
binary_tree.delete(9)
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
