class Node 
include Comparable 
    attr_accessor :data, :left, :right
    def initialize(data,left=nil,right=nil)
        @data = data
        @left = left
        @right = right
    end
    
    
end 

class Tree
    attr_accessor :root
    def initialize(array)
        @root = build_tree(array)
    end 
    def build_tree(array)
        if array.length == 1 
            data = array[0]
            node = Node.new(data)
            return node
        end
        return if array.empty?
        array.sort!
        array.uniq!
        mid  = (array.length-1)/2  
        data = array[mid]
        left = array[0...mid]
        right = array[mid+1..-1]
        left = build_tree(left)
        right = build_tree(right)
        node = Node.new(data,left,right)
    end
    
    def insert(node = @root, value)
        return unless find(value).nil?
        if node.nil?
            return Node.new(value) 
        end
        if value < node.data
            node.left = insert(node.left,value)
        else 
            node.right = insert(node.right,value)  
        end  
        node 
    end

    def delete(node = @root, value)
    
        if node.data == value 
            if node.left.nil? && node.right.nil? #remove leaf node
                return
            elsif node.left.nil? && !node.right.nil? #remove node that has only one child: left or right
                return node.right
            elsif node.right.nil? && !node.left.nil?
                return node.left
            else #remove node that has two children
                temp = node.right
                while !temp.left.nil?
                    temp = temp.left
                end
                node.right = delete(node.right, temp.data) 
                node.data = temp.data
            end
        elsif node.data < value
            node.right = delete(node.right, value)
        else
            node.left = delete(node.left, value)
        end
        node
    end
    
    def pretty_print(node = @root, prefix = '', is_left = true)

        pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
        pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
    end
    
    def find(value, node = @root)
        return if node.nil?
        return node if value == node.data
        if value < node.data
            find(value, node.left)
        else 
            find(value, node.right)
        end
    end

    def level_order_recursive(arrayData=[], queue=[@root], &block)
        node = queue[0]
        if node.nil?
            if block
                return
            else 
                return arrayData
            end
        end

        if block
            block.call(node)
        else 
            arrayData.push(node.data)
            arrayData
        end
        queue.shift
        queue.push(node.left)
        queue.push(node.right)
        queue.compact!
        level_order_recursive(arrayData, queue, &block)
    end
    
    def inorder(node = @root, arrayData = [], &block)
        if node.nil?
            if block
                return
            else 
                return arrayData
            end
        end
        inorder(node.left, arrayData, &block)
        if block
            block.call(node) 
        else 
            arrayData.push(node.data)
        end
        inorder(node.right, arrayData, &block)        
    end

    def preorder(node = @root, arrayData = [], &block)
        if node.nil?
            if block
                return
            else 
                return arrayData
            end
        end
        if block
            block.call(node) 
        else 
            arrayData.push(node.data)
        end
        preorder(node.left, arrayData, &block)
        preorder(node.right, arrayData, &block)        
    end

    def postorder(node = @root, arrayData = [], &block)
        if node.nil?
            if block
                return
            else 
                return arrayData
            end
        end
        postorder(node.left, arrayData, &block)
        postorder(node.right, arrayData, &block)        
        if block
            block.call(node) 
        else 
            arrayData.push(node.data)
        end
    end

    def height(value)
        h = 0
        node = find(value)
        parents = [node]
        children = []
        until parents.empty?
            parents.each do |parent|
                children.push(parent.left)
                children.push(parent.right)
            end
            children.compact!
            if children.empty?
                break
            else
                h += 1
            end
            parents = children.dup 
            children = []
        end
        h 
    end
    def depth(value)
        node = @root
        d = 0
        until node.data == value
            if value < node.data
                node = node.left
            else 
                node = node.right
            end 
            d += 1
        end
        d 
    end
    def balanced?(node = @root, result = true)
        if (node.left.nil? && node.right.nil?) || result == false
            return result
        elsif node.left.nil?
            diff = height(node.right.data)
        elsif node.right.nil?
            diff = height(node.left.data)
        else 
            diff = height(node.left.data) - height(node.right.data)
        end
        if diff.abs < 2
            return true if node.left.nil? || node.right.nil?
            result = balanced?(node.left, result) 
            result = balanced?(node.right, result) 
        else 
            false
        end
    end
    def rebalance
        if self.balanced?
            return self
        else 
            self.class.new(self.inorder)
        end
    end
end 
a = (Array.new(15) { rand(1..100) })
tree = Tree.new(a)
tree.pretty_print
p tree.balanced?
p tree.level_order_recursive
p tree.preorder
p tree.postorder
p tree.inorder
tree.insert(101)
tree.insert(110)
tree.insert(120)
tree.insert(130)
tree.insert(140)
tree.pretty_print
p tree.balanced?
tree = tree.rebalance
p tree.balanced?
tree.pretty_print



