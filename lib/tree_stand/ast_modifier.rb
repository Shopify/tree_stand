module TreeStand
  # An experimental class to modify the AST. I re-runs the query on the
  # modified document every loop to ensure that the match is still valid.
  # @see TreeStand::Tree
  # @api experimental
  class AstModifier
    # @param tree [TreeStand::Tree]
    def initialize(tree)
      @tree = tree
    end

    # @param query [String]
    # @yieldparam self [self]
    # @yieldparam match [TreeStand::Match]
    # @return [void]
    def on_match(query)
      matches = @tree.query(query)

      while !matches.empty?
        yield self, matches.first
        matches = @tree.query(query)
      end
    end
  end
end
