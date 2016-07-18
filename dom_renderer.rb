require_relative 'dom_reader'

class DOMRenderer

  attr_reader :tree

  def initialize(tree)
    @tree = tree
  end

  def render(node = @tree.root)
    puts "There are #{total_nodes(node)[0]} nodes below this node."
    puts "Type breakdown: #{total_nodes(node)[1]}"
    puts "Node attribute(s): #{node.attribute}" unless node.attribute.nil?
  end

  def total_nodes(node)
    type_hash = {}
    node_count = -1
    queue = [node]
    until queue.empty?
      current_node = queue.shift
      node_count += 1
      type_hash[current_node.type] ||= 0
      type_hash[current_node.type] += 1
      unless current_node.children.empty?
        current_node.children.select do |child|
          queue << child if child.is_a?(Node)
        end
      end
    end
    [node_count, type_hash]
  end

  def output(node)
    current_node = node
    return if current_node.nil?
    print current_node.tag
    current_node.children.each do |child|
      if child.is_a?(String)
        print child
      else
        output(child)
      end
    end
    print "</#{current_node.tag[1..-2]}>"
  end

end

# h = DOMReader.new(DOMLoader.load("test.html"))
# d = DOMRenderer.new(h)
# d.render