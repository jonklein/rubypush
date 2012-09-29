require 'rubypush'

describe RubyPush::Instructions do
  before(:each) do
    @interpreter = RubyPush::Interpreter.new(:stacks => [:code, :generic, :integer, :float, :boolean])
  end

  it 'should resolve instruction aliases' do
    RubyPush::Instructions.should_receive("add")
    RubyPush::Instructions.execute(@interpreter, "generic.+")
  end
  
  describe "with generic stacks" do
    it 'should execute stack.flush' do
      @interpreter.stack(:generic).push(1, 2, 3, 4, 5)
      RubyPush::Instructions.execute(@interpreter, "generic.flush")
      @interpreter.stack(:generic).should == []
    end

    it 'should execute stack.dup' do
      @interpreter.stack(:generic).push("object")
      RubyPush::Instructions.execute(@interpreter, "generic.dup")
      @interpreter.stack(:generic).should == ["object", "object"]
    end

    it 'should execute stack.pop' do
      @interpreter.stack(:generic).push("object")
      RubyPush::Instructions.execute(@interpreter, "generic.pop")
      @interpreter.stack(:generic).should == []
    end

    it 'should execute stack.= with true result' do
      @interpreter.stack(:generic).push([1,2,3], [1,2,3])
      RubyPush::Instructions.execute(@interpreter, "generic.=")
      @interpreter.stack(:boolean).should == [true]
    end

    it 'should execute stack.= with false reslut' do
      @interpreter.stack(:generic).push([1,2,3], [3,2,1])
      RubyPush::Instructions.execute(@interpreter, "generic.=")
      @interpreter.stack(:boolean).should == [false]
    end

    it 'should execute stack.swap' do
      @interpreter.stack(:generic).push(1, 2, 3, 4, 5)
      RubyPush::Instructions.execute(@interpreter, "generic.swap")
      @interpreter.stack(:generic).should == [1, 2, 3, 5, 4]
    end

    it 'should execute stack.yank' do
      @interpreter.stack(:generic).push(1, 2, 3, 4, 5)
      @interpreter.stack(:integer).push(3)
      RubyPush::Instructions.execute(@interpreter, "generic.yank")
      @interpreter.stack(:integer).should == []
      @interpreter.stack(:generic).should == [1, 3, 4, 5, 2]
    end

    it 'should execute stack.rot' do
      @interpreter.stack(:generic).push(1, 2, 3, 4, 5)
      RubyPush::Instructions.execute(@interpreter, "generic.rot")
      @interpreter.stack(:generic).should == [1, 2, 4, 5, 3]
    end

    it 'should execute stack.yankdup' do
      @interpreter.stack(:generic).push(1, 2, 3, 4, 5)
      @interpreter.stack(:integer).push(3)
      RubyPush::Instructions.execute(@interpreter, "generic.yankdup")
      @interpreter.stack(:integer).should == []
      @interpreter.stack(:generic).should == [1, 2, 3, 4, 5, 2]
    end

    it 'should execute stack.shove' do
      @interpreter.stack(:generic).push(1, 2, 3, 4, 5)
      @interpreter.stack(:integer).push(3)
      RubyPush::Instructions.execute(@interpreter, "generic.shove")
      @interpreter.stack(:integer).should == []
      @interpreter.stack(:generic).should == [1, 5, 2, 3, 4]
    end

    it 'should execute stack.stackdepth' do
      @interpreter.stack(:generic).push(1, 2, 3, 4, 5)
      RubyPush::Instructions.execute(@interpreter, "generic.stackdepth")
      @interpreter.stack(:integer).should == [5]
      @interpreter.stack(:generic).should == [1, 2, 3, 4, 5]
    end
  end

  ["integer", "float"].each do |type|
    describe "with #{type.to_s.downcase} stack" do
      before(:each) do
        @values = case type
          when "float"   then [9.0, 3.0]
          when "integer" then [9,   3]
        end
      
        @interpreter.stack(type.to_sym).push(@values[0], @values[1])
      end
    
      it "should execute #{type.to_s.downcase}.+" do
        RubyPush::Instructions.execute(@interpreter, "#{type.to_s.downcase}.+")
        @interpreter.stack(type.to_sym).should == [@values[1] + @values[0]]
      end

      it "should execute #{type.to_s.downcase}.-" do
        RubyPush::Instructions.execute(@interpreter, "#{type.to_s.downcase}.-")
        @interpreter.stack(type.to_sym).should == [@values[1] - @values[0]]
      end

      it "should execute #{type.to_s.downcase}./" do
        RubyPush::Instructions.execute(@interpreter, "#{type.to_s.downcase}./")
        @interpreter.stack(type.to_sym).should == [@values[1] / @values[0]]
      end

      it "should execute #{type.to_s.downcase.to_s}.*" do
        RubyPush::Instructions.execute(@interpreter, "#{type.to_s.downcase}.*")
        @interpreter.stack(type.to_sym).should == [@values[1] * @values[0]]
      end

      it "should execute #{type.to_s.downcase}.%" do
        RubyPush::Instructions.execute(@interpreter, "#{type.to_s.downcase}.%")
        @interpreter.stack(type.to_sym).should == [@values[1] % @values[0]]
      end

      it "should execute #{type.to_s.downcase.to_s}.=" do
        RubyPush::Instructions.execute(@interpreter, "#{type.to_s.downcase}.=")
        @interpreter.stack(:boolean).should == [@values[1] == @values[0]]
      end

      it "should execute #{type.to_s.downcase.to_s}.min" do
        RubyPush::Instructions.execute(@interpreter, "#{type.to_s.downcase}.min")
        @interpreter.stack(type.to_sym).should == [[@values[1], @values[0]].min]
      end

      it "should execute #{type.to_s.downcase.to_s}.max" do
        RubyPush::Instructions.execute(@interpreter, "#{type.to_s.downcase}.max")
        @interpreter.stack(type.to_sym).should == [[@values[1], @values[0]].max]
      end

      it "should execute #{type.to_s.downcase.to_s}.>" do
        RubyPush::Instructions.execute(@interpreter, "#{type.to_s.downcase}.>")
        @interpreter.stack(:boolean).should == [@values[1] > @values[0]]
      end

      it "should execute #{type.to_s.downcase.to_s}.<" do
        RubyPush::Instructions.execute(@interpreter, "#{type.to_s.downcase}.<")
        @interpreter.stack(:boolean).should == [@values[1] < @values[0]]
      end
    end
  end
  
  describe "with code stacks" do
    before(:each) do
    end
    
    it "should execute code.append" do
    end

    it "should execute code.do" do
    end

    it "should execute code.dostar" do
    end

    it "should execute code.dotimes" do
    end

    it "should execute code.docount" do
    end

    it "should execute code.dorange" do
    end

    it "should execute code.cons" do
      @interpreter.stack(:code).push(0, [1,2,3])
      RubyPush::Instructions.execute(@interpreter, "code.cons")
      @interpreter.stack(:code).should == [[0,1,2,3]]
    end

    it "should execute code.car" do
      @interpreter.stack(:code).push([1,2,3])
      RubyPush::Instructions.execute(@interpreter, "code.car")
      @interpreter.stack(:code).should == [1]
    end

    it "should execute code.cdr" do
      @interpreter.stack(:code).push([1,2,3])
      RubyPush::Instructions.execute(@interpreter, "code.cdr")
      @interpreter.stack(:code).should == [[2,3]]
    end

    it "should execute code.atom with true result" do
      @interpreter.stack(:code).push(5)
      RubyPush::Instructions.execute(@interpreter, "code.atom")
      @interpreter.stack(:boolean).should == [true]
    end

    it "should execute code.atom with false result" do
      @interpreter.stack(:code).push([5])
      RubyPush::Instructions.execute(@interpreter, "code.atom")
      @interpreter.stack(:boolean).should == [false]
    end

    it "should execute code.container" do
    end

    it "should execute code.contains with true result" do
      @interpreter.stack(:code).push([ 9, 10 ], [ 5, 6, 7, [ 8, [ 9,10 ] ] ])
      RubyPush::Instructions.execute(@interpreter, "code.contains")
      @interpreter.stack(:boolean).should == [true]
    end

    it "should execute code.contains with false result" do
      @interpreter.stack(:code).push([ 9, 8 ], [ 5, 6, 7, [ 8, [ 9,10 ] ] ])
      RubyPush::Instructions.execute(@interpreter, "code.contains")
      @interpreter.stack(:boolean).should == [false]
    end

    it "should execute code.extract" do
    end

    it "should execute code.if with true condition" do
      @interpreter.stack(:code).push(1, 2)
      @interpreter.stack(:boolean).push(true)
      RubyPush::Instructions.execute(@interpreter, "code.if")
      @interpreter.stack(:exec).should == [1]
      @interpreter.stack(:boolean).should == []
      @interpreter.stack(:code).should == []
    end

    it "should execute code.if with true condition" do
      @interpreter.stack(:code).push(1, 2)
      @interpreter.stack(:boolean).push(false)
      RubyPush::Instructions.execute(@interpreter, "code.if")
      @interpreter.stack(:exec).should == [2]
      @interpreter.stack(:boolean).should == []
      @interpreter.stack(:code).should == []
    end

    it "should execute code.list" do
    end

    it "should execute code.length" do
      @interpreter.stack(:code).push([5, 6, 7, [8,9]])
      RubyPush::Instructions.execute(@interpreter, "code.length")
      @interpreter.stack(:integer).should == [4]
    end

    it "should execute code.member" do
    end

    it "should execute code.noop" do
      RubyPush::Instructions.execute(@interpreter, "code.noop")
    end

    it "should execute code.nth" do
      @interpreter.stack(:code).push([5, 6, 7, [8,9]])
      @interpreter.stack(:integer).push(2)
      RubyPush::Instructions.execute(@interpreter, "code.nth")
      @interpreter.stack(:code).should == [7]
      @interpreter.stack(:integer).should == []
    end

    it "should execute code.nthcdr" do
    end

    it "should execute code.null with false result" do
      @interpreter.stack(:code).push([5, 6, 7, [8,9]])
      RubyPush::Instructions.execute(@interpreter, "code.null")
      @interpreter.stack(:code).should == []
      @interpreter.stack(:boolean).should == [false]
    end

    it "should execute code.null with true result" do
      @interpreter.stack(:code).push(nil)
      RubyPush::Instructions.execute(@interpreter, "code.null")
      @interpreter.stack(:code).should == []
      @interpreter.stack(:boolean).should == [true]
    end

    it "should execute code.position" do
      @interpreter.stack(:code).push([8,9], [5, 6, 7, [8,9]])
      RubyPush::Instructions.execute(@interpreter, "code.position")
      @interpreter.stack(:integer).should == [3]
    end

    it "should execute code.position with position not found" do
      @interpreter.stack(:code).push([8,10], [5, 6, 7, [8,9]])
      RubyPush::Instructions.execute(@interpreter, "code.position")
      @interpreter.stack(:integer).should == [-1]
    end

    it "should execute code.quote" do
      @interpreter.stack(:exec).push("some.instruction")
      RubyPush::Instructions.execute(@interpreter, "code.quote")
      @interpreter.stack(:exec).should == []
      @interpreter.stack(:code).should == ["some.instruction"]
    end

    it "should execute code.subst" do
    end
  end
end
