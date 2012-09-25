module RubyPush
  class Instructions
    ALIASES = {
      '+' => 'add',
      '-' => 'subtract',
      '/' => 'divide',
      '*' => 'multiply'
    }
    
    def self.execute(interpreter, instruction) 
      stackname, operation = instruction.split('.')
      operation = ALIASES[operation] || operation
      
      self.send(operation, interpreter, interpreter.stack(stackname.to_sym))
    end

    def self.pop(interpreter, stack)
      stack.pop if stack.length > 0
    end
    
    def self.dup(interpreter, stack)
      stack.push(stack.last) if stack.length > 0
    end

    def self.add(interpreter, stack)
      stack.push(stack.pop + stack.pop) if stack.length > 1
    end

    def self.subtract(interpreter, stack)
      stack.push(stack.pop - stack.pop) if stack.length > 1
    end

    def self.multiply(interpreter, stack)
      stack.push(stack.pop * stack.pop) if stack.length > 1
    end

    def self.divide(interpreter, stack)
      stack.push(stack.pop / stack.pop) if stack.length > 1
    end
  end
end
