require 'spec_helper'
require 'sampleable_config'

describe SampleableConfig do
  it "should generate A/B tests" do
    config = SampleableConfig.define do 
      foo do
        variant 9, "bar"
        variant 1, "biz"
      end

      enabled do
        variant 1, true
        variant 9, false
      end

      color do
        variant 8, "blue", [0, 0, 1]
        variant 1, "green", [0, 1, 0]
      end

      food "ice cream"
    end

    config.food.should == "ice cream"
    sample = config.to_sampled_config(123)
    sample.food.should == "ice cream"
    sample.foo.should == "bar"
    sample.foo(:value).should == "bar"
    sample.foo(:variant).should == "bar"
    sample.color.should == [0,0,1]
    sample.color(:value).should == [0, 0, 1]
    sample.color(:variant).should == "blue"
    sample.enabled.should == false
    sample.enabled(:value).should == false
    sample.enabled(:variant).should == "false"

    bar_count = 0
    biz_count = 0
    bad_count = 0

    1.upto(10000) do |seed|
      sample = config.to_sampled_config(seed)

      if sample.foo == "bar"
        bar_count += 1
      elsif sample.foo == "biz"
        biz_count += 1
      else 
        bad_count += 1
      end
    end

    bar_count.should be > 8500
    biz_count.should be < 1500
    bad_count.should be 0
  end

  it "should only sample once" do
    config = SampleableConfig.define do |config|
      foo do
        variant 9, "bar"
        variant 1, "biz"
      end
    end

    sample = config.to_sampled_config(123)
    expect { sample.to_sampled_config(124) }.to raise_error("Trying to sample already sampled config hash")
  end
end
