# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `ruby_tree_sitter` gem.
# Please instead update this file by running `bin/tapioca gem ruby_tree_sitter`.

# source://ruby_tree_sitter//lib/tree_sitter.rb#3
module TreeSitter
  private

  def quantifier_name(_arg0); end

  class << self
    def quantifier_name(_arg0); end
  end
end

module TreeSitter::Encoding; end
TreeSitter::Encoding::UTF16 = T.let(T.unsafe(nil), Symbol)
TreeSitter::Encoding::UTF8 = T.let(T.unsafe(nil), Symbol)

class TreeSitter::Input
  def initialize(*_arg0); end

  def inspect; end
  def payload; end
  def payload=(_arg0); end
  def to_s; end
end

class TreeSitter::InputEdit
  def inspect; end
  def new_end_byte; end
  def new_end_byte=(_arg0); end
  def new_end_point; end
  def new_end_point=(_arg0); end
  def old_end_byte; end
  def old_end_byte=(_arg0); end
  def old_end_point; end
  def old_end_point=(_arg0); end
  def start_byte; end
  def start_byte=(_arg0); end
  def start_point; end
  def start_point=(_arg0); end
  def to_s; end
end

TreeSitter::LANGUAGE_VERSION = T.let(T.unsafe(nil), Integer)

class TreeSitter::Language
  def ==(_arg0); end
  def field_count; end
  def field_id_for_name(_arg0); end
  def field_name_for_id(_arg0); end
  def symbol_count; end
  def symbol_for_name(_arg0, _arg1); end
  def symbol_name(_arg0); end
  def symbol_type(_arg0); end
  def version; end

  private

  def load(_arg0, _arg1); end

  class << self
    def load(_arg0, _arg1); end
  end
end

class TreeSitter::Logger
  def initialize(*_arg0); end

  def format; end
  def format=(_arg0); end
  def inspect; end
  def payload; end
  def payload=(_arg0); end
  def printf(*_arg0); end
  def puts(*_arg0); end
  def to_s; end
  def write(*_arg0); end
end

TreeSitter::MIN_COMPATIBLE_LANGUAGE_VERSION = T.let(T.unsafe(nil), Integer)

# source://ruby_tree_sitter//lib/tree_sitter/node.rb#4
class TreeSitter::Node
  def ==(_arg0); end

  # Access node's named children.
  #
  # It's similar to {#fetch}, but differes in input type, return values, and
  # the internal implementation.
  #
  # Both of these methods exist for separate use cases, but also because
  # sometime tree-sitter does some monkey business and having both separate
  # implementations can help.
  #
  # Comparison with {#fetch}:
  #
  #              []                            | fetch
  #              ------------------------------+----------------------
  # input types  Integer, String, Symbol       | Array<String, Symbol>
  #              Array<Integer, String, Symbol>|
  #              ------------------------------+----------------------
  # returns      1-to-1 correspondance with    | unique nodes
  #              input                         |
  #              ------------------------------+----------------------
  # uses         named_child                   | field_name_for_child
  #              child_by_field_name           |   via each_node
  #              ------------------------------+----------------------
  #
  # @param keys [Integer | String | Symbol | Array<Integer, String, Symbol>, #read]
  # @return [Node | Array<Node>]
  #
  # source://ruby_tree_sitter//lib/tree_sitter/node.rb#47
  def [](*keys); end

  def changed?; end
  def child(_arg0); end
  def child_by_field_id(_arg0); end
  def child_by_field_name(_arg0); end
  def child_count; end
  def descendant_for_byte_range(_arg0, _arg1); end
  def descendant_for_point_range(_arg0, _arg1); end

  # Iterate over a node's children.
  #
  # @yieldparam child [Node] the child
  #
  # source://ruby_tree_sitter//lib/tree_sitter/node.rb#86
  def each; end

  # Iterate over a node's children assigned to a field.
  #
  # @yieldparam name [NilClass | String] field name.
  # @yieldparam child [Node] the child.
  #
  # source://ruby_tree_sitter//lib/tree_sitter/node.rb#98
  def each_field; end

  # Iterate over a node's named children
  #
  # @yieldparam child [Node] the child
  #
  # source://ruby_tree_sitter//lib/tree_sitter/node.rb#112
  def each_named; end

  def edit(_arg0); end
  def end_byte; end
  def end_point; end
  def eq?(_arg0); end
  def error?; end
  def extra?; end

  # Access node's named children.
  #
  # It's similar to {#fetch}, but differes in input type, return values, and
  # the internal implementation.
  #
  # Both of these methods exist for separate use cases, but also because
  # sometime tree-sitter does some monkey business and having both separate
  # implementations can help.
  #
  # Comparison with {#fetch}:
  #
  #              []                            | fetch
  #              ------------------------------+----------------------
  # input types  Integer, String, Symbol       | String, Symbol
  #              Array<Integer, String, Symbol>| Array<String, Symbol>
  #              ------------------------------+----------------------
  # returns      1-to-1 correspondance with    | unique nodes
  #              input                         |
  #              ------------------------------+----------------------
  # uses         named_child                   | field_name_for_child
  #              child_by_field_name           |   via each_node
  #              ------------------------------+----------------------
  #
  # source://ruby_tree_sitter//lib/tree_sitter/node.rb#146
  def fetch(*keys); end

  # @return [Boolean]
  #
  # source://ruby_tree_sitter//lib/tree_sitter/node.rb#17
  def field?(field); end

  def field_name_for_child(_arg0); end

  # source://ruby_tree_sitter//lib/tree_sitter/node.rb#5
  def fields; end

  def first_child_for_byte(_arg0); end
  def first_named_child_for_byte(_arg0); end
  def inspect; end

  # Allows access to child_by_field_name without using [].
  #
  # source://ruby_tree_sitter//lib/tree_sitter/node.rb#70
  def method_missing(method_name, *_args, &_block); end

  def missing?; end
  def named?; end
  def named_child(_arg0); end
  def named_child_count; end
  def named_descendant_for_byte_range(_arg0, _arg1); end
  def named_descendant_for_point_range(_arg0, _arg1); end
  def next_named_sibling; end
  def next_sibling; end
  def null?; end
  def parent; end
  def prev_named_sibling; end
  def prev_sibling; end
  def start_byte; end
  def start_point; end
  def symbol; end

  # source://ruby_tree_sitter//lib/tree_sitter/node.rb#120
  def to_a; end

  def to_s; end
  def to_str; end
  def type; end

  private

  # @return [Boolean]
  #
  # source://ruby_tree_sitter//lib/tree_sitter/node.rb#78
  def respond_to_missing?(*args); end
end

class TreeSitter::Parser
  def cancellation_flag; end
  def cancellation_flag=(_arg0); end
  def included_ranges; end
  def included_ranges=(_arg0); end
  def language; end
  def language=(_arg0); end
  def logger; end
  def logger=(_arg0); end
  def parse(_arg0, _arg1); end
  def parse_string(_arg0, _arg1); end
  def parse_string_encoding(_arg0, _arg1, _arg2); end
  def print_dot_graphs(_arg0); end
  def reset; end
  def timeout_micros; end
  def timeout_micros=(_arg0); end
end

class TreeSitter::Point
  def column; end
  def column=(_arg0); end
  def inspect; end
  def row; end
  def row=(_arg0); end
  def to_s; end
end

module TreeSitter::Quantifier; end
TreeSitter::Quantifier::ONE = T.let(T.unsafe(nil), Integer)
TreeSitter::Quantifier::ONE_OR_MORE = T.let(T.unsafe(nil), Integer)
TreeSitter::Quantifier::ZERO = T.let(T.unsafe(nil), Integer)
TreeSitter::Quantifier::ZERO_OR_MORE = T.let(T.unsafe(nil), Integer)
TreeSitter::Quantifier::ZERO_OR_ONE = T.let(T.unsafe(nil), Integer)

class TreeSitter::Query
  def initialize(_arg0, _arg1); end

  def capture_count; end
  def capture_name_for_id(_arg0); end
  def capture_quantifier_for_id(_arg0, _arg1); end
  def disable_capture(_arg0); end
  def disable_pattern(_arg0); end
  def pattern_count; end
  def pattern_guaranteed_at_step?(_arg0); end
  def predicates_for_pattern(_arg0); end
  def start_byte_for_pattern(_arg0); end
  def string_count; end
  def string_value_for_id(_arg0); end
end

class TreeSitter::QueryCapture
  def index; end
  def inspect; end
  def node; end
  def to_s; end
end

class TreeSitter::QueryCursor
  def exceed_match_limit?; end
  def match_limit; end
  def match_limit=(_arg0); end
  def next_capture; end
  def next_match; end
  def remove_match(_arg0); end
  def set_byte_range(_arg0, _arg1); end
  def set_point_range(_arg0, _arg1); end

  private

  def exec(_arg0, _arg1); end

  class << self
    def exec(_arg0, _arg1); end
  end
end

module TreeSitter::QueryError; end
TreeSitter::QueryError::Capture = T.let(T.unsafe(nil), Integer)
TreeSitter::QueryError::Field = T.let(T.unsafe(nil), Integer)
TreeSitter::QueryError::Language = T.let(T.unsafe(nil), Integer)
TreeSitter::QueryError::NONE = T.let(T.unsafe(nil), Integer)
TreeSitter::QueryError::NodeType = T.let(T.unsafe(nil), Integer)
TreeSitter::QueryError::Structure = T.let(T.unsafe(nil), Integer)
TreeSitter::QueryError::Syntax = T.let(T.unsafe(nil), Integer)

class TreeSitter::QueryMatch
  def capture_count; end
  def captures; end
  def id; end
  def inspect; end
  def pattern_index; end
  def to_s; end
end

class TreeSitter::QueryPredicateStep
  def inspect; end
  def to_s; end
  def type; end
  def type=(_arg0); end
  def value_id; end
  def value_id=(_arg0); end
end

TreeSitter::QueryPredicateStep::CAPTURE = T.let(T.unsafe(nil), Symbol)
TreeSitter::QueryPredicateStep::DONE = T.let(T.unsafe(nil), Symbol)
TreeSitter::QueryPredicateStep::STRING = T.let(T.unsafe(nil), Symbol)

class TreeSitter::Range
  def end_byte; end
  def end_byte=(_arg0); end
  def end_point; end
  def end_point=(_arg0); end
  def inspect; end
  def start_byte; end
  def start_byte=(_arg0); end
  def start_point; end
  def start_point=(_arg0); end
  def to_s; end
end

module TreeSitter::SymbolType; end
TreeSitter::SymbolType::ANONYMOUS = T.let(T.unsafe(nil), Symbol)
TreeSitter::SymbolType::AUXILIARY = T.let(T.unsafe(nil), Symbol)
TreeSitter::SymbolType::REGULAR = T.let(T.unsafe(nil), Symbol)

class TreeSitter::Tree
  def copy; end
  def edit(_arg0); end
  def language; end
  def print_dot_graph(_arg0); end
  def root_node; end

  private

  def changed_ranges(_arg0, _arg1); end
  def finalizer; end

  class << self
    def changed_ranges(_arg0, _arg1); end
    def finalizer; end
  end
end

class TreeSitter::TreeCursor
  def initialize(_arg0); end

  def copy; end
  def current_field_id; end
  def current_field_name; end
  def current_node; end
  def goto_first_child; end
  def goto_first_child_for_byte(_arg0); end
  def goto_first_child_for_point(_arg0); end
  def goto_next_sibling; end
  def goto_parent; end
  def reset(_arg0); end
end

# source://ruby_tree_sitter//lib/tree_sitter/version.rb#4
TreeSitter::VERSION = T.let(T.unsafe(nil), String)
