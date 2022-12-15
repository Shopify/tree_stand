module TreeStand
  # Wrapper around a TreeSitter tree.
  #
  # This class exposes a convient API for working with the tree. There are
  # dangers in using this class. The tree is mutable and the document can be
  # changed. This class does not protect against that.
  #
  # Some of the moetods on this class edit and re-parse the document updating
  # the tree. Because the document is re-parsed, the tree will be different. Which
  # means all outstanding nodes & ranges will be invalid.
  #
  # Methods that edit the document are suffixed with `!`, e.g. `#edit!`.
  #
  # It's often the case that you will want perfrom multiple edits. One such
  # pattern is to call #query & #edit on all matches in a loop. It's important
  # to keep the destructive nature of #edit in mind and re-issue the query
  # after each edit.
  #
  # Another thing to keep in mind is that edits done later in the document will
  # likely not affect the ranges that occur earlier in the document. This can
  # be a convient property that could allow you to apply edits in a reverse order.
  # This is not always possible and depends on the edits you make, beware that
  # the tree will be different after each edit and this approach may cause bugs.
  class Tree
    # @return [String]
    attr_reader :document
    # @return [TreeSitter::Tree]
    attr_reader :ts_tree
    # @return [TreeStand::Parser]
    attr_reader :parser

    # @api private
    def initialize(parser, tree, document)
      @parser = parser
      @ts_tree = tree
      @document = document
    end

    # @return [TreeStand::Node]
    def root_node
      TreeStand::Node.new(self, @ts_tree.root_node)
    end

    # (see TreeStand::Node#query)
    # @note This is a convenience method that calls {TreeStand::Node#query} on
    #   {#root_node}.
    # @see TreeStand::Node#query
    def query(query_string)
      root_node.query(query_string)
    end

    # This method replaces the section of the document specified by range and
    # replaces it with the provided text. Then it will reparse the document and
    # update the tree!
    # @param range [TreeStand::Range]
    # @param replacement [String]
    # @return [void]
    def edit!(range, replacement)
      new_document = +""
      new_document << @document[0...range.start_byte]
      new_document << replacement
      new_document << @document[range.end_byte..-1]
      replace_with_new_doc(new_document)
    end

    # This method deletes the section of the document specified by range Then
    # it will reparse the document and update the tree!
    # @param range [TreeStand::Range]
    # @return [void]
    def delete!(range)
      new_document = +""
      new_document << @document[0...range.start_byte]
      new_document << @document[range.end_byte..-1]
      replace_with_new_doc(new_document)
    end

    private

    def replace_with_new_doc(new_document)
      @document = new_document
      new_tree = @parser.parse_string(@ts_tree, @document)
      @ts_tree = new_tree.ts_tree
    end
  end
end
