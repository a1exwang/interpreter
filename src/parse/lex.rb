module AlexRuby
  module Parse
    class Lexer
      def self.lex(str)
        tokens = []
        until str.empty?
          case str
            when /^(;|\n)/
              # KEYWORD 'end of statement'
              tokens.push [:END_OF_STATEMENT, ';']
            when /^\s+/
              # skip the spaces and tabs
              # tokens.push [:SPACE, $&]
            when /^(\+|-|\*|\/|\(|\)|=|\{|\}|,)/
              # operators
              tokens.push [$&, $&]
            when /^(p|print)\s/
              tokens.push [:PRINT, $&]
            when /^(def|do|end)/
              # keywords
              tokens.push [$&, $&]
            when /^[_A-Za-z][_A-Za-z0-9]*/
              # identifier
              tokens.push [:IDENTIFIER, $&]
            when /^[0-9]+/
              # digits
              tokens.push [:NUMBER, $&.to_i]
            else
              puts 'Lexer Error'
          end
          str = $'
        end
        tokens.push [false, '$end']
        tokens
      end

      def initialize(str)
        @tokens = Lexer.lex(str)
      end

      def to_s
        return nil unless @tokens

        @tokens.each do |token|
          puts "#{token[0]}\t\t#{token[1]}"
        end
      end
    end
  end
end