require_relative './visitor'

module AlexRuby
  module Compile

    module Visitors
      class TreeVisitor < Visitor
        attr_accessor :str
        def traverse_tree(node)
          visit(node)
        end

        def reset
          @str = ''
          @indents = 0
        end

        def initialize(indents = 0)
          reset
          @indents = indents
        end

        protected

        # helpers
        def indent_inc
          if block_given?
            @indents += 1
            yield
            @indents -= 1
          else
            @indents += 1
          end

        end
        def indent_dec
          @indents -= 1
        end

        def append(*s)
          @str += s.join(' ')
        end

        def append_line(*s)
          append_indent
          append(*s)
          @str += "\n"
        end

        def append_indent
          @str += "\t" * @indents
          self
        end

        # visitor methods
        def visit_statement(node)
          traverse_tree(node.expression)
        end

        def visit_statements(node)
          append_line('statements')
          indent_inc do
            node.statements.each do |s|
              traverse_tree(s)
            end
          end
        end

        def visit_reference(node)
          append_line "reference #{node.name}"
        end

        def visit_assign(node)
          append_line "assign #{node.lhs.name}"
          traverse_tree(node.rhs)
        end

        def visit_operator(node)
          append_line 'operator', node.name
          indent_inc do
            traverse_tree(node.operands.first)
            traverse_tree(node.operands.last)
          end
        end

        def visit_number(node)
          append_line("number #{node.value}")
        end

        def visit_print(node)
          append_line('print')
          indent_inc do
            traverse_tree(node.expression)
          end
        end

        def visit_function_def(node)
          append_line("def #{node.name}")
          indent_inc do
            append_line('arguments')
            indent_inc do
              node.arguments.each do |arg|
                append_line(arg)
              end
            end
            append_line('body')
            indent_inc do
              traverse_tree(node.body)
            end
          end
        end

        def visit_function_call(node)
          append_line("call #{node.name}")
          indent_inc do
            node.parameters.each { |p| traverse_tree(p) }
          end
        end

        def visit_block(node)
          append_line('block')
          indent_inc do
            traverse_tree(node.statements)
          end
        end
      end
    end
  end
end