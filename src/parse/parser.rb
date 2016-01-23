#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.14
# from Racc grammer file "".
#

require 'racc/parser.rb'

require_relative 'lex'
require_relative 'ast'

module AlexRuby
  module Parse
    class Parser < Racc::Parser

module_eval(<<'...end parser.rb.y/module_eval...', 'parser.rb.y', 63)
  attr_accessor :root

  def initialize
  end

  def parse(str)
    @q = Lexer.lex(str)
    do_parse
  end

  def next_token
    @q.shift
  end
...end parser.rb.y/module_eval...
##### State transition tables begin ###

racc_action_table = [
     7,     8,    12,    11,     7,     8,    19,    11,    10,    23,
     6,     9,    10,    25,     6,     9,    20,    49,    21,    48,
     7,     8,    30,    11,     7,     8,    36,    11,    10,    45,
     6,     9,    10,   nil,     6,     9,     7,     8,   nil,    11,
     7,     8,   nil,    11,    10,    17,    18,     9,    10,     7,
     8,     9,    11,     7,     8,   nil,    11,    10,    17,    18,
     9,    10,     7,     8,     9,    11,     7,     8,   nil,    11,
    10,    37,    38,     9,    10,     7,     8,     9,    11,     7,
     8,   nil,    11,    10,    39,    40,     9,    10,     7,     8,
     9,    11,     7,     8,   nil,    11,    10,   nil,   nil,     9,
    10,   nil,     6,     9,     7,     8,   nil,    11,    17,    18,
    15,    16,    10,   nil,     6,     9,    17,    18,    15,    16,
    43,    14,    44,    34,    17,    18,    15,    16,    17,    18,
    15,    16,    17,    18,    15,    16,    17,    18,    15,    16 ]

racc_action_check = [
    47,    47,     1,    47,    46,    46,     6,    46,    47,    10,
    47,    47,    46,    12,    46,    46,     8,    47,     8,    46,
     0,     0,    19,     0,     2,     2,    30,     2,     0,    40,
     0,     0,     2,   nil,     2,     2,     9,     9,   nil,     9,
    11,    11,   nil,    11,     9,    26,    26,     9,    11,    15,
    15,    11,    15,    16,    16,   nil,    16,    15,    27,    27,
    15,    16,    17,    17,    16,    17,    18,    18,   nil,    18,
    17,    33,    33,    17,    18,    20,    20,    18,    20,    21,
    21,   nil,    21,    20,    35,    35,    20,    21,    38,    38,
    21,    38,    43,    43,   nil,    43,    38,   nil,   nil,    38,
    43,   nil,    43,    43,    44,    44,   nil,    44,    24,    24,
    24,    24,    44,   nil,    44,    44,    22,    22,    22,    22,
    39,     4,    39,    22,     4,     4,     4,     4,    31,    31,
    31,    31,    32,    32,    32,    32,    41,    41,    41,    41 ]

racc_action_pointer = [
    18,     2,    22,   nil,   117,   nil,     3,   nil,     5,    34,
     7,    38,    13,   nil,   nil,    47,    51,    60,    64,     9,
    73,    77,   109,   nil,   101,   nil,    38,    51,   nil,   nil,
    23,   121,   125,    57,   nil,    70,   nil,   nil,    86,   104,
    26,   129,   nil,    90,   102,   nil,     2,    -2,   nil,   nil ]

racc_action_default = [
   -26,   -26,    -1,    -3,   -26,    -5,   -26,    -7,    -8,   -26,
   -26,   -26,   -26,    -2,    -4,   -26,   -26,   -26,   -26,   -26,
   -26,   -21,   -26,   -14,   -17,    50,   -10,   -11,   -12,   -13,
   -18,   -15,   -22,   -26,    -9,   -26,   -19,   -16,   -26,   -26,
   -26,   -23,    -6,   -26,   -26,   -20,   -26,   -26,   -24,   -25 ]

racc_goto_table = [
    13,     1,    22,     2,    24,    35,    42,    33,    26,    27,
    28,    29,   nil,    31,    32,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,    41,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,    13,    13,    46,    47 ]

racc_goto_check = [
     3,     1,     4,     2,     4,     6,     7,     8,     4,     4,
     4,     4,   nil,     4,     4,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,     4,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,     3,     3,     2,     2 ]

racc_goto_pointer = [
   nil,     1,     3,    -2,    -7,   nil,   -25,   -33,   -14 ]

racc_goto_default = [
   nil,   nil,   nil,     3,     4,     5,   nil,   nil,   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  1, 21, :_reduce_1,
  2, 22, :_reduce_2,
  1, 22, :_reduce_3,
  2, 23, :_reduce_4,
  1, 23, :_reduce_5,
  6, 25, :_reduce_6,
  1, 24, :_reduce_7,
  1, 24, :_reduce_8,
  3, 24, :_reduce_9,
  3, 24, :_reduce_10,
  3, 24, :_reduce_11,
  3, 24, :_reduce_12,
  3, 24, :_reduce_13,
  2, 24, :_reduce_14,
  3, 24, :_reduce_15,
  4, 24, :_reduce_16,
  2, 24, :_reduce_17,
  0, 26, :_reduce_18,
  1, 26, :_reduce_19,
  3, 26, :_reduce_20,
  0, 28, :_reduce_21,
  1, 28, :_reduce_22,
  3, 28, :_reduce_23,
  3, 27, :_reduce_24,
  3, 27, :_reduce_25 ]

racc_reduce_n = 26

racc_shift_n = 50

racc_token_table = {
  false => 0,
  :error => 1,
  :NUMBER => 2,
  :IDENTIFIER => 3,
  :END_OF_STATEMENT => 4,
  :PRINT => 5,
  :UNARY_MINUS => 6,
  "*" => 7,
  "/" => 8,
  "+" => 9,
  "-" => 10,
  "=" => 11,
  "def" => 12,
  "(" => 13,
  ")" => 14,
  "," => 15,
  "{" => 16,
  "}" => 17,
  "do" => 18,
  "end" => 19 }

racc_nt_base = 20

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "NUMBER",
  "IDENTIFIER",
  "END_OF_STATEMENT",
  "PRINT",
  "UNARY_MINUS",
  "\"*\"",
  "\"/\"",
  "\"+\"",
  "\"-\"",
  "\"=\"",
  "\"def\"",
  "\"(\"",
  "\")\"",
  "\",\"",
  "\"{\"",
  "\"}\"",
  "\"do\"",
  "\"end\"",
  "$start",
  "target",
  "statements",
  "statement",
  "exp",
  "function_def",
  "argument_list",
  "block",
  "parameter_list" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

module_eval(<<'.,.,', 'parser.rb.y', 12)
  def _reduce_1(val, _values, result)
     @root = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.rb.y', 14)
  def _reduce_2(val, _values, result)
     result = AST::Statements.new(val[0], val[1]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.rb.y', 15)
  def _reduce_3(val, _values, result)
     result = AST::Statements.new(val[0]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.rb.y', 17)
  def _reduce_4(val, _values, result)
     result = AST::Statement.new(val[0]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.rb.y', 18)
  def _reduce_5(val, _values, result)
     result = AST::Statement.new(val[0]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.rb.y', 21)
  def _reduce_6(val, _values, result)
            result = AST::FunctionDef.new(val[1], val[3].arguments, val[5])
  
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.rb.y', 24)
  def _reduce_7(val, _values, result)
     result = AST::Number.new(val[0].to_i); 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.rb.y', 25)
  def _reduce_8(val, _values, result)
     result = AST::Reference.new(val[0]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.rb.y', 27)
  def _reduce_9(val, _values, result)
     result = val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.rb.y', 29)
  def _reduce_10(val, _values, result)
     result = AST::Operator.new('+', val[0], val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.rb.y', 30)
  def _reduce_11(val, _values, result)
     result = AST::Operator.new('-', val[0], val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.rb.y', 31)
  def _reduce_12(val, _values, result)
     result = AST::Operator.new('*', val[0], val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.rb.y', 32)
  def _reduce_13(val, _values, result)
     result = AST::Operator.new('/', val[0], val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.rb.y', 33)
  def _reduce_14(val, _values, result)
     result = AST::Operator.new('@-', val[1]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.rb.y', 36)
  def _reduce_15(val, _values, result)
     result = AST::Assign.new(AST::Identifier.new(val[0]), val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.rb.y', 40)
  def _reduce_16(val, _values, result)
            puts val[0]
        result = AST::FunctionCall.new(val[0], val[2].parameters)
     
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.rb.y', 45)
  def _reduce_17(val, _values, result)
     result = AST::Print.new(val[1]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.rb.y', 47)
  def _reduce_18(val, _values, result)
     result = AST::ArgumentList.new 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.rb.y', 48)
  def _reduce_19(val, _values, result)
     result = AST::ArgumentList.new(val[0]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.rb.y', 49)
  def _reduce_20(val, _values, result)
     result = AST::ArgumentList.new(*val[0].arguments.push(val[2])) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.rb.y', 50)
  def _reduce_21(val, _values, result)
     result = AST::ParameterList.new 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.rb.y', 51)
  def _reduce_22(val, _values, result)
     result = AST::ParameterList.new(nil, val[0]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.rb.y', 52)
  def _reduce_23(val, _values, result)
     result = AST::ParameterList.new(val[0] ? val[0].parameters : nil, val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.rb.y', 54)
  def _reduce_24(val, _values, result)
     result = AST::Block.new(val[1]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.rb.y', 55)
  def _reduce_25(val, _values, result)
     result = AST::Block.new(val[1]) 
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

    end   # class Parser
    end   # module Parse
  end   # module AlexRuby