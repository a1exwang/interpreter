require_relative '../../parse/ast'
AST = AlexRuby::Parse::AST

module AlexRuby
  module Compile
    module Visitors
      class Visitor
        # visitor stubs
        def visit_operator(node); end
        def visit_assign(node); end
        def visit_reference(node); end
        def visit_number(node); end
        def visit_identifier(node); end
        def visit_statement(node); end
        def visit_print(node); end
        def visit_statements(node); end
        def visit_function_def(node); end
        def visit_function_call(node); end
        def visit_block(node); end

        def visit(node)
          case node
            when AST::Operator
              visit_operator(node)
            when AST::Assign
              visit_assign(node)
            when AST::Reference
              visit_reference(node)
            when AST::Number
              visit_number(node)
            when AST::Identifier
              visit_identifier(node)
            when AST::Statement
              visit_statement(node)
            when AST::Statements
              visit_statements(node)
            when AST::Print
              visit_print(node)
            when AST::FunctionDef
              visit_function_def(node)
            when AST::FunctionCall
              visit_function_call(node)
            when AST::Block
              visit_block(node)
            else
              raise RuntimeError.new("Unknown node type #{node}")
          end
        end
      end
    end
  end
end