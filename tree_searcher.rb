require_relative 'dom_reader'
require_relative 'dom_renderer'

class TreeSearcher

  def initialize(tree)
    @tree = tree
  end

  def find_node(node_tag)
    queue = [@tree.root]
    until queue.empty?
      current_node = queue.shift
      return current_node if current_node.tag == node_tag
      current_node.children.each do |child|
        queue << child if child.is_a?(Node)
      end
    end
  end

  def search_by(attr, value, node = @tree.root)
    matched_nodes = []
    queue = [node]
    until queue.empty?
      current_node = queue.shift
      matched_nodes << current_node if current_node.attribute[attr] == value
      current_node.children.each do |child|
        queue << child if child.is_a?(Node)
      end
    end
    matched_nodes
  end

  def search_children(node_tag, attr, value)
    search_node = find_node(node_tag)
    search_by(attr, value, search_node)
  end

  def search_ancestors(node_tag, attr, value)
    search_node = find_node(node_tag)
    matched_nodes = []
    queue = [search_node.parent]
    until queue.empty?
      current_node = queue.shift
      matched_nodes << current_node if current_node.attribute[attr] == value
      queue << current_node.parent if current_node.parent.is_a?(Node)
    end
    matched_nodes
  end

end

h = DOMReader.new(DOMLoader.load("test.html"))
d = DOMRenderer.new(h)
t = TreeSearcher.new(h)
# puts t.find_node("<html>")
# main_area = t.search_by(:id, "main-area")
# main_area.each {|node| d.render(node)}
# body_search = t.search_children("<body>", :class, "emphasized")
# body_search.each {|node| d.render(node)}
parent_search = t.search_ancestors("<h2>", :class, "super-header")
parent_search.each {|node| d.render(node)}
