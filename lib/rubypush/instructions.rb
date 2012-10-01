module RubyPush
  class Instructions
    ALIASES = {
      '+' => 'add',
      '-' => 'subtract',
      '/' => 'divide',
      '*' => 'multiply',
      '%' => 'mod',
      '=' => 'equals',
      '>' => 'greaterthan',
      '<' => 'lessthan'
    }
    
  class << self
    def execute(interpreter, instruction) 
      stackname, operation = instruction.split('.')
      operation = ALIASES[operation] || operation

      begin
        send(operation, interpreter, interpreter.stack(stackname.to_sym))
      rescue Exception => e
        puts "Could not execute instruction #{instruction}: #{e.inspect}"
      end
    end
    
    def to_list(item)
      item.is_a?(Array) ? item : [item]
    end
    
    def contains_item(list, item) 
      list.index(item) ? true : list.select{ |l| l.is_a?(Array) }.any?{ |l| contains_item(l, item) }
    end
    
    # generic stack instructions

    def flush(interpreter, stack)
      stack.clear
    end

    def stackdepth(interpreter, stack)
      interpreter.stack(:integer).push(stack.length)
    end

    def pop(interpreter, stack)
      stack.pop if stack.length > 0
    end
    
    def dup(interpreter, stack)
      stack.push(stack.last) if stack.length > 0
    end
    
    def yank(interpreter, stack)
      if interpreter.stack(:integer).length > 0 && stack.length > 0
        index = interpreter.stack(:integer).pop % stack.length
        value = stack[-index - 1]
        stack.slice!(-index - 1)
        stack.push(value)
      end
    end

    def yankdup(interpreter, stack)
      if interpreter.stack(:integer).length > 0 && stack.length > 0
        index = interpreter.stack(:integer).pop % stack.length
        stack.push(stack[-index - 1])
      end
    end

    def shove(interpreter, stack)
      if interpreter.stack(:integer).length > 0 && stack.length > 1
        value = stack.pop
        index = interpreter.stack(:integer).pop % stack.length
        stack.insert(-index - 1, value)
      end
    end

    def rot(interpreter, stack)
      stack.push(stack.slice!(-3)) if stack.length > 2
    end

    def swap(interpreter, stack)
      if stack.length > 1
        a = stack.pop
        b = stack.pop
        stack.push(a, b)
      end
    end
    
    # mathematical instructions

    def add(interpreter, stack)
      stack.push(stack.pop + stack.pop) if stack.length > 1
    end

    def subtract(interpreter, stack)
      stack.push(stack.pop - stack.pop) if stack.length > 1
    end

    def multiply(interpreter, stack)
      stack.push(stack.pop * stack.pop) if stack.length > 1
    end

    def divide(interpreter, stack)
      if stack.length > 1
        a = stack.pop
        b = stack.pop
        stack.push(b == 0.0 ? b : a / b) 
      end
    end

    def mod(interpreter, stack)
      if stack.length > 1
        a = stack.pop
        b = stack.pop
        stack.push(b == 0.0 ? b : a % b) 
      end
    end

    def max(interpreter, stack)
      stack.push([stack.pop, stack.pop].max) if stack.length > 1
    end

    def min(interpreter, stack)
      stack.push([stack.pop, stack.pop].min) if stack.length > 1
    end
    
    def equals(interpreter, stack)
      interpreter.stack(:boolean).push(stack.pop == stack.pop) if stack.length > 1
    end

    def lessthan(interpreter, stack)
      interpreter.stack(:boolean).push(stack.pop < stack.pop) if stack.length > 1
    end

    def greaterthan(interpreter, stack)
      interpreter.stack(:boolean).push(stack.pop > stack.pop) if stack.length > 1
    end
    
    # code instructions

    def append(interpreter, stack)
      if stack.length > 1
        a = to_list(stack.pop)
        b = to_list(stack.pop)
        stack.push(a + b)
      end
    end

    def do(interpreter, stack)
      interpreter.stack(:exec).push("code.pop", stack.pop) if stack.length > 0
    end

    def dostar(interpreter, stack)
      interpreter.stack(:exec).push(stack.pop) if stack.length > 0
    end
    
    def dotimes(interpreter, stack)
      interpreter.stack(:exec).push([0, interpreter.stack(:integer).pop - 1, "code.quote", to_list(stack.pop).push("integer.pop"), "code.do*range"]) if stack.length > 0 && interpreter.stack(:integer).length > 0
    end

    def docount(interpreter, stack)
      interpreter.stack(:exec).push([0, interpreter.stack(:integer).pop - 1, "code.quote", stack.pop, "code.do*range"]) if stack.length > 0 && interpreter.stack(:integer).length > 0
    end

    def dorange(interpreter, stack)
      if stack.length > 0 && interpreter.stack(:integer).length > 1
        start = interpreter.stack(:integer).pop
        finish = interpreter.stack(:integer).pop
        interpreter.stack(:exec).push()
      end
    end

    def cons(interpreter, stack)
      if stack.length > 1
        list = to_list(stack.pop)
        item = stack.pop
        stack.push(list.unshift(item))
      end
    end

    def cdr(interpreter, stack)
      if stack.length > 0
        code = stack.pop
        code.shift
        stack.push(code)
      end
    end

    def car(interpreter, stack)
      if stack.length > 0
        code = to_list(stack.pop)
        stack.push(code.shift)
      end
    end

    def atom(interpreter, stack)
      if stack.length > 0
        code = stack.pop
        interpreter.stack(:boolean).push(!code.is_a?(Array))
      end
    end

    def container(interpreter, stack)
    end

    def contains(interpreter, stack)
      if stack.length > 1
        code = stack.pop
        sub = stack.pop
        
        interpreter.stack(:boolean).push(contains_item(code, sub))
      end
    end

    def extract(interpreter, stack)
    end

    def if(interpreter, stack)
      if interpreter.stack(:boolean).length > 0 && stack.length > 1
        f = stack.pop
        t = stack.pop
        
        interpreter.stack(:exec).push(interpreter.stack(:boolean).pop ? t : f)
      end
    end

    def list(interpreter, stack)
      if stack.length > 1
        a = stack.pop
        b = stack.pop
        
        stack.push([a, b])
      end
    end

    def length(interpreter, stack)
      interpreter.stack(:integer).push(stack.pop.length) if stack.length > 0
    end

    def member(interpreter, stack)
      if stack.length > 1
        code = stack.pop
        sub = stack.pop
        
        interpreter.stack(:boolean).push(!code.index(sub).nil?)
      end
    end

    def noop(interpreter, stack)
      # noop
    end

    def nth(interpreter, stack)
      if interpreter.stack(:integer).length > 0 && stack.length > 0
        code = to_list(stack.pop)
  
        stack.push(code[interpreter.stack(:integer).pop % code.length]) if code.length > 0
      end
    end

    def nthcdr(interpreter, stack)
    end

    def null(interpreter, stack)
      interpreter.stack(:boolean).push(stack.pop == nil) if stack.length > 0
    end

    def position(interpreter, stack)
      if stack.length > 1
        code = to_list(stack.pop)
        sub = stack.pop
        interpreter.stack(:integer).push(code.index(sub) || -1)
      end
    end

    def quote(interpreter, stack)
      stack.push(interpreter.stack(:exec).pop) if interpreter.stack(:exec).length > 0
    end

    def subst(interpreter, stack)
    end
  end
  
  end
end
