require 'rubypush'

describe RubyPush::Interpreter do 
  before(:each) do
    @interpreter = RubyPush::Interpreter.new
  end
  
  describe 'by default' do
    it 'should return stacks' do
      @interpreter.stack(:exec).should == []
    end

    it 'should create stacks for the appropriate types' do
      types = [:exec, :integer, :some_other_stack]
      @interpreter = RubyPush::Interpreter.new(:stacks => [:exec, :integer, :some_other_stack])
      
      types.each { |t| @interpreter.stack(t).should == [] }
      [:float, :code].each { |t| @interpreter.stack(t).should be_nil }
    end
    
    it 'should clear stacks' do
      types = [:exec, :integer]
      types.each { |t| @interpreter.stack(t).push(1) }
      @interpreter.clear_stacks
      types.each { |t| @interpreter.stack(t).should == [] }
    end
  end
  
  describe 'execution' do
    it 'should push a program onto the exec stack with prepare' do
      @interpreter.prepare([1, 2, 3])
      @interpreter.stack(:exec).should == [ [ 1, 2, 3 ] ]
    end
  
    it 'should execute atomic values from the exec stack by pushing on to other stacks' do
      @interpreter.prepare(1)
      @interpreter.step

      @interpreter.stack(:exec).should == []
      @interpreter.stack(:integer).should == [1]
      @interpreter.stack(:float).should == []

      @interpreter.clear_stacks
      
      @interpreter.prepare(1.0)
      @interpreter.step

      @interpreter.stack(:exec).should == []
      @interpreter.stack(:integer).should == []
      @interpreter.stack(:float).should == [1.0]
    end

    it 'should execute string values from the exec stack by performing instructions' do
      @interpreter.stack(:integer).push(1,1)
      @interpreter.prepare("integer.+")
      @interpreter.step
      @interpreter.stack(:integer).should == [2]
    end

    it 'should execute list values from the exec stack by expanding onto the exec stack' do
      @interpreter.prepare([1, 2, [3]])
      @interpreter.step
      @interpreter.stack(:exec).should == [[3], 2, 1]
    end

    it 'should execute programs composed of the above steps' do
      @interpreter.execute([1, 2, "integer.+"], 100)
      @interpreter.stack(:integer).should == [3]
    end
  end
end
