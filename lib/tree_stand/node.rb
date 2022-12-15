module TreeStand
  # Wrapper around a TreeSitter node and provides convient
  # methods that are missing on the original node. This class
  # overrides the `method_missing` method to delegate to a nodes
  # named children.
  class Node
    extend Forwardable
    include Enumerable

    def_delegators :@ts_node, :type, :start_byte, :end_byte, :start_point, :end_point

    # @return [TreeStand::Tree]
    attr_reader :tree
    # @return [TreeSitter::Node]
    attr_reader :ts_node

    # @api private
    def initialize(tree, ts_node)
      @tree = tree
      @ts_node = ts_node
      @fields = @ts_node.each_field.to_a.map(&:first)
    end

    # @return [TreeStand::Range]
    def range
      TreeStand::Range.new(
        start_byte: @ts_node.start_byte,
        end_byte: @ts_node.end_byte,
        start_point: @ts_node.start_point,
        end_point: @ts_node.end_point,
      )
    end

    # Node includes enumerable so that you can iterate over the child nodes.
    # @yieldparam child [TreeStand::Node]
    # @return [Enumerator]
    def each
      @ts_node.each do |child|
        yield TreeStand::Node.new(@tree, child)
      end
    end

    # @return [TreeStand::Node]
    def parent
      TreeStand::Node.new(@tree, @ts_node.parent)
    end

    # A convience method for getting the text of the node. Each TreeStand Node
    # wraps the parent tree and has access to the source document.
    # @return [String]
    def text
      @tree.document[@ts_node.start_byte...@ts_node.end_byte]
    end

    # This class overrides the `method_missing` method to delegate to the
    # node's named children. This allows you to write code like this:
    #   root = tree.root_node
    #   child = root.expression
    # @overload method_missing(field_name)
    #   @param name [Symbol, String]
    #   @return [TreeStand::Node] Child node for the given field name
    #   @raise [NoMethodError] Raised if the node does not have child with name `field_name`
    #
    # @overload method_missing(method_name, *args, &block)
    #   @raise [NoMethodError]
    def method_missing(method, *args, &block)
      return super unless @fields.include?(method.to_s)
      TreeStand::Node.new(@tree, @ts_node.public_send(method, *args, &block))
    end

    # @param other [Object]
    # @return [bool]
    def ==(other)
      return false unless other.is_a?(TreeStand::Node)

      range == other.range &&
        type == other.type &&
        text == other.text
    end
  end
end
