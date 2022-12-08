module TreeStand
  class Node
    extend Forwardable
    include Enumerable

    def_delegators :@ts_node, :type, :start_byte, :end_byte, :start_point, :end_point

    def initialize(tree, ts_node)
      @tree = tree
      @ts_node = ts_node
      @fields = @ts_node.each_field.to_a.map(&:first)
    end

    def range
      TreeStand::Range.new(
        start_byte: @ts_node.start_byte,
        end_byte: @ts_node.end_byte,
        start_point: @ts_node.start_point,
        end_point: @ts_node.end_point,
      )
    end

    def each
      @ts_node.each do |child|
        yield TreeStand::Node.new(@tree, child)
      end
    end

    def parent
      TreeStand::Node.new(@tree, @ts_node.parent)
    end

    def text
      @tree.document[@ts_node.start_byte...@ts_node.end_byte]
    end

    def method_missing(method, *args, &block)
      return super unless @fields.include?(method.to_s)
      TreeStand::Node.new(@tree, @ts_node.public_send(method, *args, &block))
    end

    def ==(other)
      return false unless other.is_a?(TreeStand::Node)

      range == other.range &&
        type == other.type &&
        text == other.text
    end
  end
end
