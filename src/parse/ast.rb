module AlexRuby
  module Parse
    module AST

      class Number
        attr_accessor :value
        def initialize(v)
          @value = v
        end
      end

      class Identifier
        attr_accessor :name
        def initialize(n)
          @name = n
        end
      end
      class Assign
        attr_accessor :lhs, :rhs
        def initialize(l, r)
          @lhs = l
          @rhs = r
        end
      end
      class Reference
        attr_accessor :name
        def initialize(n)
          @name = n
        end
      end

      class Operator
        attr_accessor :name, :operands
        def initialize(n, *ops)
          @name = n
          @operands = ops
        end
      end

      class FunctionDef
        attr_accessor :name, :arguments, :body
        def initialize(name, arguments, body)
          @name = name
          @arguments = arguments
          @body = body
        end
      end
      class ArgumentList
        attr_accessor :arguments
        def initialize(*arguments)
            @arguments = arguments
        end
      end
      class FunctionCall
        attr_accessor :name, :parameters
        def initialize(name, params)
          @name = name
          @parameters = params
        end
      end
      class ParameterList
        attr_accessor :parameters
        def initialize(parameters = nil, parameter = nil)
          if parameters.nil?
            if parameter.nil?
              @parameters = []
            else
              @parameters = [parameter]
            end
          else
            @parameters = parameters + [parameter]
          end
        end
      end

      class Block
        attr_accessor :statements
        def initialize(statements)
          @statements = statements
        end
      end

      class Print
        attr_accessor :expression
        def initialize(exp)
          @expression = exp
        end
      end

      class Statements
        attr_accessor :statements
        def initialize(s, statement = nil)
          if statement == nil
            # s is a statement
            @statements = [s]
          else
            @statements = s.statements.push(statement)
          end
        end
      end
      class Statement
        attr_accessor :expression
        def initialize(exp)
          @expression = exp
        end
      end
    end
  end
end
