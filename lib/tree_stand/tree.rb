module TreeStand
  class Tree
    attr_reader :document, :ts_tree

    def initialize(parser, tree, document)
      @parser = parser
      @ts_tree = tree
      @document = document
    end

    def root_node
      TreeStand::Node.new(self, @ts_tree.root_node)
    end

    def query(query_string)
      ts_query = TreeSitter::Query.new(@parser.ts_language, query_string)
      ts_cursor = TreeSitter::QueryCursor.exec(ts_query, @ts_tree.root_node)
      matches = []
      while match = ts_cursor.next_match
        matches << TreeStand::Match.new(self, ts_query, match)
      end
      matches
    end

    def edit(range, new_text)
      new_document = +""
      new_document << @document[0...range.start_byte]
      new_document << new_text
      new_document << @document[range.end_byte..-1]
      replace_with_new_doc(new_document)
    end

    def delete(range)
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
