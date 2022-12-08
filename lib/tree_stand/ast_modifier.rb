module TreeStand
  class AstModifier
    def initialize(tree)
      @tree = tree
    end

    def on_match(query_string)
      matches = @tree.query(query_string)

      while !matches.empty?
        yield self, matches.first
        matches = @tree.query(query_string)
      end
    end
  end
end
