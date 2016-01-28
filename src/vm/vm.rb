require 'json'

module AlexRuby
  module VM
    module Errors
      TypeError = ::Class.new(RuntimeError)
      ArgumentError = ::Class.new(ArgumentError)
    end

    module Type
      def self.check_immediate(val)
        val.is_a?(Fixnum) ||
            val.is_a?(String) ||
            val.is_a?(Symbol) ||
            val.is_a?(Float) ||
            val.is_a?(Array)
      end
    end

    class Value
      attr_accessor :type
      attr_accessor :object
      def initialize(type, object)
        self.type = type
        self.object = object
      end
    end

    class Object < Value
      attr_accessor :clazz, :instance_variables
      def initialize(clazz)
        super(:object, self)
        self.clazz = clazz
        self.instance_variables = {}
      end
    end

    class Class < Value
      attr_accessor :name, :super, :instance_methods, :vm, :outer_scope_constant
      def initialize(vm, name, outer_scope_constant = nil, superclass = nil, first_class = false)
        super(:class, self)
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
      def define_instance_method_block(name, &block)
        self.instance_methods[name] = Method.new(self, name, :block, block)
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
      # instruction => [{name: name, params: xx}, ...]
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
      def self.included(othermod)
        def othermod.ins(name, in_params = {}, out_params = {}, immediate = {}, &block)
          define_method("ins_#{name}".to_sym) do |imp = {}|

            real_in_params = {}
            in_params_array = stack.pop(in_params.size)
            in_params.each_with_index do |pair, index|
              k, v = pair
              if v.nil?
                real_in_params[k] = in_params_array[index]
              elsif v.is_a?(::Proc)
                if v.call(in_params_array[index])
                  real_in_params[k] = in_params_array[index]
                else
                  raise Errors::TypeError
                end
              elsif in_params_array[index].is_a?(v)
                real_in_params[k] = in_params_array[index]
              else
                raise Errors::TypeError.new("name: #{name}, in:#{in_params}, out:#{out_params}")
              end
            end

            real_im_params = {}
            immediate.each do |k, v|
              if imp.key?(k)
                if v.nil?
                  real_im_params[k] = imp[k]
                elsif v.is_a?(::Proc)
                  if v.call(imp[k])
                    real_im_params[k] = imp[k]
                  else
                    raise Errors::TypeError
                  end
                elsif imp[k].is_a?(v)
                  real_im_params[k] = imp[k]
                else
                  raise Errors::TypeError
                end
              else
                raise Errors::ArgumentError
              end
            end

            outp = yield self, real_in_params, real_im_params

            out_params.each do |k, v|
              if v.nil?
                stack.push outp[k]
              elsif v.is_a?(::Proc)
                if v.call(outp[k])
                  stack.push outp[k]
                else
                  raise Errors::TypeError
                end
              elsif outp[k].is_a?(v)
                stack.push outp[k]
              else
                raise Errors::TypeError
              end
            end
          end
        end
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

      ins(:push_immediate,
          { },
          { :immediate => nil },
          { :immediate => lambda { |v| Type.check_immediate(v) } }
      ) do |vm, p, im|
        { immediate: im[:immediate] }
      end

      ins(:pop, { item: nil }) do |vm, p, im|
        {}
      end

      ins(:load_constant,
          { constant_name: ::String },
          { constant: Value }
      ) do |vm, p, im|
        { constant: vm.constant_table[p[:constant_name]] }
      end

      ins(:dup,
          { value: nil },
          { value: nil, value1: nil }
      ) do |vm, p, im|
        { value: p[:value], value1: p[:value] }
      end

      ins(:call_instance_method,
          { name: ::String, receiver: Value, params: ::Array },
          { ret: nil }
      ) do |vm, p, im|
        { ret: vm.call_instance_method(p[:name], p[:receiver], p[:params])}
      end

      ins(:define_class,
          { outer_scope: Scope, superclass_full_name: String, name: String },
          { clazz: Class }
      ) do |vm, p, im|
        { clazz: define_class(p[:name], p[:superclass_full_name], p[:outer_scope]) }
      end

      ins(:new_object,
          { clazz: Class },
          { object: Object }
      ) do |vm, p, im|
        object = p[:clazz].create_object
        # call_instance_method('respond_to?'.to_sym, object, [:initialize])
        { object: object }
      end

      ins(:iv_set,
          { object: nil, name: String, value: nil }
      ) do |vm, p, im|
        p[:object].instance_variables[p[:name]] = p[:value]
        {}
      end

      ins(:iv_get,
          { object: nil, name: String },
          { value: nil }
      ) do |vm, p, im|
        { value: p[:object].instance_variables[p[:name]] }
      end

      ins(:local_set_l0,
          { name: String, value: nil }
      ) do |vm, p, im|
        vm.current_scope.local_table[p[:name]] = p[:value]
        {}
      end
      ins(:local_get_l0,
          { name: String },
          { value: nil }
      ) do |vm, p, im|
        value = vm.current_scope.local_table[p[:name]]
        { value: value }
      end

      ins(:nop) { |vm, p, im| {} }
      ins(:params,
          { },
          { params: nil },
          { count: Integer }
      ) do |vm, p, im|
        { params: vm.stack.pop(im[:count]) }
      end

      def eval_instruction(instruction)
        name = instruction.first
        params = instruction.size == 2 ? instruction.last : []
        begin
          send("ins_#{name}".to_sym, params)
        rescue Exception => e
          puts instruction.inspect
          raise e
        end
      end

      def execute(start = 0)
        # initialize the infrastructures
        self.top_scope = Scope.new(self, :top)
        self.constant_table[''] = self.top_scope
        self.current_scope = self.top_scope
        define_class  'Class'
        define_class  'Integer'

        define_builtin_instance_method 'puts', 'Object' do |obj, str|
          puts str
        end
        define_builtin_instance_method 'gets', 'Object' do |obj|
          gets
        end
        define_instance_method_block 'initialize', 'Integer' do |obj, value|
          obj.object.instance_variables[:value] = value
        end
        define_instance_method_block '+', 'Integer' do |obj, other|
          obj.object.instance_variables[:value] + other.object.instance_variables[:value]
        end

        ins_push_immediate immediate: 'Object'
        ins_load_constant
        ins_new_object
        ins_dup

        obj = @stack.last
        call_instance_method('puts', obj, 'hello world!')

        open('../../test/vm.json') do |f|
          current_scope.instructions = JSON.parse(f.read, symbolize_names: true)
        end

        current_scope.instructions.each do |ins|
          puts "ins:#{ins}, stack:#{stack.last(3)}"
          eval_instruction(ins)

        end

      end

      def define_class(name, superclass_full_name = nil, outer_scope = nil)
        outer_scope_constant = outer_scope || constant_table[top_scope.constant_full_name]
        superclass = superclass_full_name ? constant_table[superclass_full_name] : constant_table['Object']
        clazz = Class.new(self, name, outer_scope_constant, superclass)
        constant_table[clazz.name] = clazz
      end

      def define_instance_method(name, class_name, method_scope)
        clazz = constant_table[class_name]
        clazz.define_instance_method(name, method_scope)
      end

      def define_instance_method_block(name, class_name, &block)
        clazz = constant_table[class_name]
        clazz.define_instance_method_block(name, &block)
      end

      def define_builtin_instance_method(name, class_name, &block)
        clazz = constant_table[class_name]
        clazz.define_builtin_instance_method(name, &block)
      end

      def call_instance_method(method_name, receiver, params)
        method = receiver.clazz.instance_methods[method_name]
        if method.type == :builtin
          ret = receiver.send(method_name.to_sym, *params)
          puts "=> #{ret.inspect}"
          ret
        elsif method.type == :block
          ret = method.scope.call(receiver, *params)
          puts "=> #{ret.inspect}"
          ret
        else
          # prepare to call the method
          puts "call #{method_name} on #{receiver}"
        end
      end

    end
  end
end

machine = AlexRuby::VM::Machine.new
machine.execute