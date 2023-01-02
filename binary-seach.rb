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

  def build_tree(arr, arr_start = 0, arr_end = arr.length-1)
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

    if value == node.data
      # Value to delete has been found
      #puts "Found node for delete(#{value}): #{node.data}"
      return amount_of_children(node)

    elsif value > node.data
      # Go right to find value to delete
      #puts "Going right at #{node.data}"
      rightnode = delete(value, node.right)
      #puts "current node: #{node.data}, rightnode: #{rightnode}"

      if rightnode == 0
        # 0 Children on node to the right
        node.right = nil

      elsif rightnode == 1
        # 1 Child on node to the right, determine whether it is on the left or right
        if !node.right.left.nil?
          node.left = node.right.left
        elsif !node.right.right.nil?
          node.right = node.right.right
        end

      elsif rightnode == 2
        # 2 Children on node to the right
        largest_value = find_next_largest(node.right.right)
        #puts "largest_value: #{largest_value}, data: #{largest_value.data}"
        node.right.data = largest_value.data

      end

    elsif value < node.data
      # Go left to find value to delete
      #puts "Going left at #{node.data}"
      leftnode = delete(value, node.left)
      #puts "current node: #{node.data}, leftnode: #{leftnode}"

      if leftnode == 0
        # 0 Children on node to the left
        node.left = nil

      elsif leftnode == 1
        # 1 Child on node to the left
        if !node.left.left.nil?
          node.left = node.left.left
        elsif !node.left.right.nil?
          node.left = node.left.right
        end

      elsif leftnode == 2
        # 2 Children on node to the left
        largest_value = find_next_largest(node.left.right)
        node.left.data = largest_value.data

      end

    end
  end

  def find_next_largest(node)
    # Keep recursing left until no left branch is found
    if node.left.nil?
      self.delete(node.data)
      return node
    else
      find_next_largest(node.left)
    end
  end

  def amount_of_children(node)
    if node.left.nil? && node.right.nil?
      # The node to delete has 0 children
      #puts "#{node.data} has 0 children"
      return 0

    elsif !node.left.nil? && !node.right.nil?
      # The node 2 children
      #puts "#{node.data} has 2 children"
      return 2

    elsif node.left.nil? || node.right.nil?
      # The node has 1 child, either left or right
      #puts "#{node.data} has 1 child"
      return 1

    end
  end

  def level_order(queue = [@root], &block)
    # queue.push: add to back, queue.shift: remove from front
    
    return_arr = []

    while !queue.empty?
      next_node = queue.shift

      if block_given?
        block.call(next_node)
      else
        return_arr << next_node
      end

      queue.push(next_node.left) if !next_node.left.nil?
      queue.push(next_node.right) if !next_node.right.nil?
    end

    return return_arr if !block_given?
    return nil
  end

  def preorder(node = @root, arr = [], &block)
    # Root -> Left -> Right
    if block_given?
      block.call(node)
      leftnode = preorder(node.left, arr, &block) if !node.left.nil?
      rightnode = preorder(node.right, arr, &block) if !node.right.nil?
    else
      arr << node
      leftnode = preorder(node.left, arr) if !node.left.nil?
      rightnode = preorder(node.right, arr) if !node.right.nil?
      return arr
    end
  end

  def inorder(node = @root, arr = [], &block)
    # Left -> Root -> Right
    if block_given?
      leftnode = inorder(node.left, arr, &block) if !node.left.nil?
      block.call(node)
      rightnode = inorder(node.right, arr, &block) if !node.right.nil?

    else
      leftnode = inorder(node.left, arr) if !node.left.nil?
      arr << node
      rightnode = inorder(node.right, arr) if !node.right.nil?
      return arr
    end
  end

  def postorder(node = @root, arr = [], &block)
    # Left -> Right -> Root
    if block_given?
      leftnode = postorder(node.left, arr, &block) if !node.left.nil?
      rightnode = postorder(node.right, arr, &block) if !node.right.nil?
      block.call(node)
    else
      leftnode = postorder(node.left, arr) if !node.left.nil?
      rightnode = postorder(node.right, arr) if !node.right.nil?
      arr << node
    end
  end

  def height(node = @root)
    return 0 if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)
    return [left_height, right_height].max + 1
  end

  def depth(target, node = @root, count = 0)
    return count + 1 if target == node.data

    if target < node.data
      depth(target, node.left, count + 1) if !node.left.nil?
    elsif target > node.data
      depth(target, node.right, count + 1) if !node.right.nil?
    end
  end

  def balanced?(node = @root)
    if node.nil?
      #puts "Node nil, returning -1"
      return -1
    end

    #puts "Going left at #{node.data}"
    left_tree = balanced?(node.left)
    return left_tree if left_tree == false

    #puts "Going right at #{node.data}"
    right_tree = balanced?(node.right)
    return right_tree if right_tree == false

    balance = (left_tree - right_tree).abs
    #puts "(#{node.data}) left_tree - right_tree = #{balance}"

    return false if balance > 1
    return true if node == @root
    balance
  end

  def rebalance
    sorted_array = self.inorder.map { |node| node.data }
    new_tree = build_tree(sorted_array)
    @root = new_tree
  end
end

arr = Array.new(15) { rand(1..100) }
binary_tree = Tree.new(arr)

binary_tree.insert(100)
binary_tree.insert(150)
binary_tree.insert(115)
binary_tree.print_tree
print "\n"

puts "Level Order: "
binary_tree.level_order { |node| print "#{node.data} " }; print "\n\n"

puts "Preorder: "
binary_tree.preorder { |node| print "#{node.data} " }; print "\n\n"

puts "Inorder: "
binary_tree.inorder { |node| print "#{node.data} " }; print "\n\n"

puts "Postorder: "
binary_tree.postorder { |node| print "#{node.data} " }; print "\n\n"

p binary_tree.balanced?
binary_tree.rebalance
binary_tree.print_tree
print "\n"

puts "Level Order: "
binary_tree.level_order { |node| print "#{node.data} " }; print "\n\n"

puts "Preorder: "
binary_tree.preorder { |node| print "#{node.data} " }; print "\n\n"

puts "Inorder: "
binary_tree.inorder { |node| print "#{node.data} " }; print "\n\n"

puts "Postorder: "
binary_tree.postorder { |node| print "#{node.data} " }; print "\n\n"
