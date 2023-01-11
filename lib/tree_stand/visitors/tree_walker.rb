module TreeStand
  # A collection of useful visitors for traversing trees.
  module Visitors
    # Walks the tree depth-first and yields each node to the provided block.
    #
    # @example Create a list of all the nodes in the tree.
    #   list = []
    #   TreeStand::Visitors::TreeWalker.new(root) do |node|
    #     list << node
    #   end.visit
    #
    # @see TreeStand::Node#walk
    # @see TreeStand::Tree#walk
    class TreeWalker < Visitor
      # @param node [TreeStand::Node]
      # @param block [Proc] A block that will be called for
      #   each node in the tree.
      def initialize(node, &block)
        super(node)
        @block = block
      end

      private

      def _on_default(node)
        @block.call(node)
      end
    end
  end
end
