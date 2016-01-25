module AlexRuby
  module VM
    module Errors
      TypeError = ::Class.new(RuntimeError)
    end

    module Type
      def self.check_immediate(val)
        val.is_a?(Fixnum) ||
            val.is_a?(String) ||
            val.is_a?(Symbol) ||
            val.is_a?(Float)
      end
    end

    class Object
      attr_accessor :clazz, :instance_variables
      def initialize(clazz)
        self.clazz = clazz
        self.instance_variables = {}
      end

      def to_json

      end
    end

    class Class
      attr_accessor :name, :super, :instance_methods, :vm, :outer_scope_constant
      def initialize(vm, name, outer_scope_constant = nil, superclass = nil, first_class = false)
        self.vm = vm

        if first_class
          self.name = name
        else
          self.outer_scope_constant = outer_scope_constant || vm.top_scope
          self.name = self.outer_scope_constant.constant_full_name == '' ?
              name : "#{self.outer_scope_constant.constant_full_name}::#{name}"

          if self.outer_scope_constant == vm.top_scope && name.to_s == 'Object'
            self.super = nil
          else
            self.super = superclass || vm.constant_table['Object']
          end
        end

        self.instance_methods = {}
      end

      def create_object
        Object.new(self)
      end

      def define_instance_method(name, scope)
        self.instance_methods[name] = Method.new(self, name, :normal, scope)
      end
      def define_builtin_instance_method(name, &block)
        self.instance_methods[name] = Method.new(self, name, :builtin, block)
      end

    end

    class Top < Class
      def initialize(vm)
        super(vm, '')
      end
    end
    class Method
      # the type could be: :normal, :builtin
      # for builtin methods, scope is a ruby block with the first parameter obj and the rest of the parameters followed
      attr_accessor :clazz, :name, :scope, :type
      def initialize(clazz, name, type = :normal, scope = nil)
        self.type = type
        self.clazz = clazz
        self.name = name
        self.scope = scope
      end
    end
    class Block

    end

    class Scope
      # scope's unique name
      attr_accessor :name
      attr_accessor :self
      attr_accessor :clazz
      attr_accessor :constant_full_name

      # scope type: [:top, :class, :method, :block]
      attr_accessor :type
      # one of Class, Method or Block object
      attr_accessor :entity

      # stores local variables
      attr_accessor :local_table

      # outer lexical scope
      attr_accessor :outer_scope

      # an array of instructions
      # instruction => [name, p1, p2...]
      attr_accessor :instructions
      attr_accessor :vm

      # initialize by variables or json
      def initialize(vm, type, lt = nil, outer = nil, instructions = nil)
        hash = nil
        if type.is_a?(String)
          hash = JSON.parse(type)
        elsif type.is_a?(Hash)
          hash = type
        end

        if hash
          type = hash[:type]
          lt = hash[:local_table]
          outer = hash[:outer_scope]
          instructions = hash[:instructions]
        end

        self.vm = vm
        self.name = "\##{type}:#{Random.rand(0xFFFFFFFF).to_s(16)}"
        self.type = type
        case type
          when :top
            clazz = Class.new(vm, 'Object', self, nil, true)
            vm.constant_table['Object'] = clazz
            self.entity = clazz
            self.constant_full_name = ''
          when :class
            self.entity = vm.define_class('a')
            self.constant_full_name = entity.name
          when :method
          when :block
          else
            raise Errors::TypeError
        end
        self.local_table = lt || {}
        self.outer_scope = outer || nil
        self.clazz = get_current_class
        self.instructions = instructions || []
      end

      def get_current_class
        if type == :class
          entity
        elsif outer_scope
          outer_scope.get_current_class
        else
          vm.constant_table['Object']
        end
      end

      def to_json
        {
            type:         self.type,
            local_table:  self.local_table,
            outer_scope:  self.outer_scope,
            instructions: self.instructions
        }.to_json
      end
    end

    class Snippet
      attr_accessor :metadata
      # metadata format:
      # {
      #   version: 1
      #   scopes: [...]
      # }

      # block:
      #

      def initialize(v)
        if v.is_a? String
          self.metadata = JSON.parse(v)
        elsif v.is_a? Hash
          self.metadata = v
        else
          raise "#{v}: Unknown initialization type!"
        end
      end
      def to_json
        metadata.to_json
      end

    end

    module Instructions

      # @param:   immediate value
      # @used:
      # @produced: immediate value
      def ins_push_immediate(val)
        if Type.check_immediate(val)
          stack << val
        else
          raise Errors::TypeError
        end
      end
      def ins_pop
        stack.pop
      end
      def ins_dup
        stack.push(stack.last)
      end

      def ins_save_to_local
        value = stack.pop
        local_name = stack.pop
        current_scope.local_table[local_name] = value
      end
      def ins_load_from_local
        local_name = stack.pop
        stack.push(current_scope.local_table[local_name])
      end

      def ins_call_method
        params = stack.pop
        receiver = stack.pop
        method_name = stack.pop.to_sym

        call_method(receiver, method_name, params)
        stack.push(nil)
      end
      def ins_new_object
        clazz = stack.pop
        stack.push(clazz.create_object)
      end

      def ins_load_constant
        constant_name = stack.pop
        stack.push(constant_table[constant_name])
      end

      def ins_define_class

      end
      def ins_define_instance_method

      end


    end
    class Machine
      attr_accessor :stack

      attr_accessor :scopes
      attr_accessor :top_scope
      attr_accessor :current_scope

      attr_accessor :constant_table

      def initialize
        @stack = []
        @scopes = []
        @constant_table = {}
      end

      def add_snippet(snippet)
        @scopes += snippet.metadata[:scopes]
      end

      include Instructions
      def execute(start = 0)

        # if @scopes.size > start
        #   @current_scope = @scopes[start]
        #
        #   loop do
        #   end
        #
        # end

        # initialize the infrastructures
        self.top_scope = Scope.new(self, :top)
        self.current_scope = self.top_scope
        define_class  'Class'
        define_builtin_instance_method 'puts', 'Object' do |obj, str|
          puts str
        end
        ins_push_immediate  'Object'
        ins_load_constant
        ins_new_object
        ins_dup
        obj = @stack.last
        call_method('puts', obj, 'hello world!')

      end

      def define_class(name, superclass_full_name = nil)
        outer_scope_constant = current_scope ? constant_table[current_scope.name] : top_scope
        superclass = superclass_full_name ? constant_table[superclass_full_name] : constant_table['Object']
        clazz = Class.new(self, name, outer_scope_constant, superclass)
        constant_table[clazz.name] = clazz
      end

      def define_instance_method(name, class_name, scope)
        clazz = constant_table[class_name]
        clazz.define_instance_method(name, scope)
      end

      def define_builtin_instance_method(name, class_name, &block)
        clazz = constant_table[class_name]
        clazz.define_builtin_instance_method(name, &block)
      end

      def call_method(method_name, obj, params)
        method = obj.clazz.instance_methods[method_name]
        if method.type == :builtin
          ret = obj.send(method_name.to_sym, *params)
          puts "=> #{ret.inspect}"
          ret
        else
          # prepare to call the method
          puts "call #{method_name} on #{obj}"
        end
      end

    end
  end
end

machine = AlexRuby::VM::Machine.new
machine.execute