require_relative 'dom_loader'

Node = Struct.new(:tag, :children, :parent, :attribute, :type)

class DOMReader

  attr_reader :root

  OPENING = /<([a-z]*?)>/
  CLOSING = /<\/([a-z]*?)>/
  BOTH = /<.*?>/

  def initialize(html)
    @root = Node.new("", [], nil, {}, "document") 
    @html = html
    parser
  end

  def tags
    @html.scan(BOTH)
  end

  def text
    @html.split(BOTH)
  end

  def parser
    tags_array = tags
    text_array = text[1..-1]
    current_parent = @root
    current_node = create_node(tags_array.shift, current_parent)
    current_parent.children << current_node
    current_node.children << text_array.shift
    until tags_array.empty?
      if tags_array[0].include?("/") && current_node.tag.include?(tags_array[0][3..-2])
        current_node = current_node.parent
        tags_array.shift
        current_node.children << text_array.shift
      else
        current_parent = current_node
        current_node = create_node(tags_array.shift, current_parent)
        current_parent.children << current_node
        current_node.children << text_array.shift
      end
    end
  end

  def create_node(tag, parent)
    attribute_hash = {}
    if tag.include?("id=")
      attribute_hash[:id] = tag.match(/id="(.*?)"/)[1]
    elsif tag.include?("class=")
      attribute_hash[:class] = tag.match(/class="(.*?)"/)[1]
    end
    type = tag.match(/<(?<name>\w+)(?<attributes>\s+[^>]*|)>/)[1]
    Node.new(tag, [], parent, attribute_hash, type)
  end

end

# h = DOMReader.new(DOMLoader.load("test.html"))

# h.outputter(h.root)