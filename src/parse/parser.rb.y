class AlexRuby::Parse::Parser
  token NUMBER IDENTIFIER END_OF_STATEMENT PRINT
  prechigh
    nonassoc UNARY_MINUS
    left '*' '/'
    left '+' '-'
    right '='
    right PRINT
  preclow
  start target

rule
  target: statements { @root = val[0] }

  statements: statements statement { result = AST::Statements.new(val[0], val[1]) }
     | statement { result = AST::Statements.new(val[0]) }

  statement: exp END_OF_STATEMENT { result = AST::Statement.new(val[0]) }
     | function_def { result = AST::Statement.new(val[0]) }

  function_def: 'def' IDENTIFIER '(' argument_list ')' block {
        result = AST::FunctionDef.new(val[1], val[3].arguments, val[5])
  }

  exp: NUMBER { result = AST::Number.new(val[0].to_i); }
     | IDENTIFIER { result = AST::Reference.new(val[0]) }

     | '(' exp ')' { result = val[1] }
     # math operators
     | exp '+' exp { result = AST::Operator.new('+', val[0], val[2]) }
     | exp '-' exp { result = AST::Operator.new('-', val[0], val[2]) }
     | exp '*' exp { result = AST::Operator.new('*', val[0], val[2]) }
     | exp '/' exp { result = AST::Operator.new('/', val[0], val[2]) }
     | '-' NUMBER =UNARY_MINUS { result = AST::Operator.new('@-', val[1]) }

     # variable definition
     | IDENTIFIER '=' exp { result = AST::Assign.new(AST::Identifier.new(val[0]), val[2]) }

     # function call
     | IDENTIFIER '(' parameter_list ')' {
        puts val[0]
        result = AST::FunctionCall.new(val[0], val[2].parameters)
     }

     # Core functions
     | PRINT exp { result = AST::Print.new(val[1]) }

  argument_list: { result = AST::ArgumentList.new }
     | IDENTIFIER { result = AST::ArgumentList.new(val[0]) }
     | argument_list ',' IDENTIFIER { result = AST::ArgumentList.new(*val[0].arguments.push(val[2])) }
  parameter_list: { result = AST::ParameterList.new }
     | exp { result = AST::ParameterList.new(nil, val[0]) }
     | parameter_list ',' exp { result = AST::ParameterList.new(val[0] ? val[0].parameters : nil, val[2]) }

  block: '{' statements '}' { result = AST::Block.new(val[1]) }
     | 'do' statements 'end' { result = AST::Block.new(val[1]) }
end
---- header
require_relative 'lex'
require_relative 'ast'

---- inner
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

