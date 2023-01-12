module TreeStand
  # A collection of useful methods for working with syntax trees.
  module Utils
    # Used to {TreeStand::Node#pretty_print pretty-print} the node.
    #
    # @example
    #   pp node
    #   # (expression
    #   #  (sum
    #   #   left: (number)              | 1
    #   #   ("+")                       | +
    #   #   right: (variable)))         | x
    class Printer
      # @param ralign [Integer] the right alignment for the text column.
      def initialize(ralign:)
        @ralign = ralign
      end

      # (see TreeStand::Utils::Printer)
      #
      # @param node [TreeStand::Node]
      # @param io [IO]
      # @return [IO]
      def print(node, io: StringIO.new)
        lines = pretty_output_lines(node)

        lines.each do |line|
          if line.text.empty?
            io.puts line.sexpr
            next
          end

          io.puts "#{line.sexpr}#{" " * (@ralign - line.sexpr.size)}| #{line.text}"
        end

        io
      end

      private

      Line = Struct.new(:sexpr, :text)
      private_constant :Line

      def pretty_output_lines(node, prefix: "", depth: 0)
        indent = " " * depth
        ts_node = node.ts_node
        if indent.size + prefix.size + ts_node.to_s.size < @ralign || ts_node.child_count == 0
          return [Line.new("#{indent}#{prefix}#{ts_node}", node.text)]
        end

        lines = [Line.new("#{indent}#{prefix}(#{ts_node.type}", "")]

        node.each.with_index do |child, index|
          lines += if field_name = ts_node.field_name_for_child(index)
            pretty_output_lines(
              child,
              prefix: "#{field_name}: ",
              depth: depth + 1,
            )
          else
            pretty_output_lines(child, depth: depth + 1)
          end
        end

        lines.last.sexpr << ")"
        lines
      end
    end
  end
end
