module RubyPush
  class Interpreter
    def initialize(opts = {})
      stack_types = opts.delete(:stacks) { [:integer, :float] }.push(:exec)
      @stacks = stack_types.reduce({}) { |m,n| m[n] = []; m }
      @instructions = []
    end
    
    def stack(type)
      @stacks[type.to_sym]
    end
    
    def stacks 
      @stacks
    end
    
    def clear_stacks
      @stacks.values.each { |s| s.clear }
    end

    def parse(program) 
      parse_tokens(program.scan(/([\w\.\"\'\+\-\*\/\=%]+|\)|\()/), [])[0]
    end
    
    def parse_tokens(tokens, program)
      while tokens.length > 0
        return program if (token = tokens.shift[0]) == ")"
        
        if token.match(/^[0-9]+$/)
          token = token.to_i 
        elsif token.match(/^[0-9\.]+$/)
          token = token.to_f
        end

        program.push(token == "(" ? parse_tokens(tokens, []) : token)
      end
      
      program
    end    

    def execute(program, limit = 99999999)
      program = parse(program) if program.is_a?(String)
      
      clear_stacks
      prepare(program)
      limit.times { return unless step }
    end
    
    def prepare(program)
      @stacks[:exec].push(program)
    end

    def step
      return false unless value = @stacks[:exec].pop

      case value
      when Fixnum   then @stacks[:integer].push(value) 
      when Float    then @stacks[:float].push(value) 
      when Array    then @stacks[:exec] += value.reverse
      when String   then execute_instruction(value)
      else raise "Unknown instruction type: #{value.class.to_s}"
      end
      
      true
    end
    
    private
    
    def execute_instruction(instruction)
      Instructions.execute(self, instruction)
    end
  end
end
