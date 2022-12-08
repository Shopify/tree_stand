module TreeStand
  class Visitor
    def initialize(node)
      @node = node
    end

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
