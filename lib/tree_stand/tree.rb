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

    # TreeSitter uses a `TreeSitter::Cursor` to iterate over matches by calling
    # `curser#next_match` repeatedly until it returns `nil`.
    #
    # This method does all of that for you and collects them into an array.
    #
    # @see TreeStand::Match
    # @see TreeStand::Capture
    #
    # @param query_string [String]
    # @return [Array<TreeStand::Match>]
    def query(query_string)
      ts_query = TreeSitter::Query.new(@parser.ts_language, query_string)
      ts_cursor = TreeSitter::QueryCursor.exec(ts_query, @ts_tree.root_node)
      matches = []
      while match = ts_cursor.next_match
        matches << TreeStand::Match.new(self, ts_query, match)
      end
      matches
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
