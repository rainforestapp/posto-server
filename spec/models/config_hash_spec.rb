require 'spec_helper'

describe ConfigHash do
  it "should generate A/B tests" do
    config = ConfigHash.new

    config.foo :ab, 
      9 => "bar", 
      1 => "biz"

    1.upto(1000) do
      sample = config.to_sample_config(123)
      sample.foo.should == "bar"
    end

    bar_count = 0
    biz_count = 0
    bad_count = 0

    1.upto(100000) do |seed|
      sample = config.to_sample_config(seed)

      if sample.foo == "bar"
        bar_count += 1
      elsif sample.foo == "biz"
        biz_count += 1
      else 
        bad_count += 1
      end
    end

    bar_count.should be > 85000
    biz_count.should be < 15000
    bad_count.should be 0
  end

  it "should only sample once" do
    config = ConfigHash.new

    config.foo :ab, 
      9 => "bar", 
      1 => "biz"

    sample = config.to_sample_config(123)
    expect { sample.to_sample_config(123) }.to raise_error("Trying to sample already sampled config hash")
  end
end
