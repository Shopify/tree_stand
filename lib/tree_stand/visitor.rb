module TreeStand
  # Depth-first traversal through the tree, calling hooks at each stop.
  #
  # Hooks are language depended so are defined by creating methods on the
  # visitor with the form `on_#{node.type}`.
  #
  # You can also define an `_on_default` method to run on all nodes.
  #
  # @example Create a visitor counting certain nodes
  #   class CountingVisitor < TreeStand::Visitor
  #     attr_reader :count
  #
  #     def initialize(document, type:)
  #       super(document)
  #       @type = type
  #       @count = 0
  #     end
  #
  #     def on_predicate(node)
  #       # if this node matches our search, increment the counter
  #       @count += 1 if node.type == @type
  #     end
  #   end
  #
  #   # Initialize a visitor
  #   visitor = CountingVisitor.new(document, :predicate).visit
  #   # Check the result
  #   visitor.count
  #   # => 3
  class Visitor
    # @param node [TreeStand::Node]
    def initialize(node)
      @node = node
    end

    # Run the visitor on the document and return self. Allows chaining create and visit.
    # @example
    #   visitor = CountingVisitor.new(node, :predicate).visit
    # @return [self]
    def visit
      visit_node(@node)
      self
    end

    private

    def visit_node(node)
      if respond_to?("on_#{node.type}")
        public_send("on_#{node.type}", node)
      elsif respond_to?(:_on_default)
        _on_default(node)
      end

      node.each do |child|
        visit_node(child)
      end
    end
  end
end
