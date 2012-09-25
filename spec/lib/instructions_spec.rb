require 'rubypush'

describe RubyPush::Instructions do
  before(:each) do
    @interpreter = RubyPush::Interpreter.new(:stacks => [:generic, :integer, :float])
  end

  it 'should resolve instruction aliases' do
    RubyPush::Instructions.should_receive("add")
    RubyPush::Instructions.execute(@interpreter, "generic.+")
  end
  
  describe "with generic stacks" do
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
  end

  ["integer", "float"].each do |type|
    describe "with #{type.to_s.downcase} stack" do
      before(:each) do
        @values = case type
          when "float"   then [9.0, 3.0]
          when "integer" then [9,   3]
        end
      
        @interpreter.stack(type.to_sym).push(@values[0])
        @interpreter.stack(type.to_sym).push(@values[1])
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
    end
  end
end
