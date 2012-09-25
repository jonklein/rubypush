module RubyPush
  class Interpreter
    def initialize(opts = {})
      stack_types = opts.delete(:stacks) { [:integer, :float, :string] }.push(:exec)
      
      @stacks = stack_types.reduce({}) { |m,n| m[n] = []; m }
    end
    
    def stack(type)
      @stacks[type.to_sym]
    end
    
    def clear_stacks
      @stacks.values.each { |s| s.clear }
    end

    def execute(program, limit = 0)
      clear_stacks
      prepare(program)
      limit.times { step }
    end
    
    def prepare(program)
      @stacks[:exec].push(program)
    end

    def step
      value = @stacks[:exec].pop

      case value
      when NilClass then nil
      when Fixnum   then @stacks[:integer].push(value) 
      when Float    then @stacks[:float].push(value) 
      when Array    then @stacks[:exec] += value.reverse
      when String   then execute_instruction(value)
      else raise "Unknown instruction type: #{value.class.to_s}"
      end
    end
    
    private
    
    def execute_instruction(instruction)
      Instructions.execute(self, instruction)
    end
  end
end
