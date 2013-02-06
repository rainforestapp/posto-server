require "zlib"

class SampleableConfig < Hash
  def self.define(&block)
    SampleableConfig.new.tap do |config|
      Builder.new(config).instance_eval(&block)
    end
  end

  def to_sampled_config(seed)
    raise "Trying to sample already sampled config hash" if @sampled

    SampleableConfig.new(true).tap do |sample|
      self.each do |k, v|
        unless v.kind_of?(ConfigAB)
          sample[k] = v
        else
          # Seed off of key name also so cross-config buckets are not aligned
          sample[k] = v.value_for_seed(seed + Zlib::crc32(k.to_s))
        end
      end
    end
  end

  private

  class ConfigAB < Hash
    def value_for_seed(seed)
      weight_sum = self.values.map { |v| v[:weight] }.reduce(:+)
      r = Random.new(seed).rand

      variant_value = nil
      variant_name = nil

      self.each do |name, tuple|
        weight = tuple[:weight]
        variant_value = tuple[:value]
        variant_name = name.to_s

        break if r <= (weight.to_f / weight_sum.to_f)
      end

      if variant_value.nil?
        variant_name = self.keys.last.to_s
        variant_value = self[self.keys.last][:value]
      end

      { :variant => variant_name, :value => variant_value }
    end
  end

  def initialize(sampled = false)
    @sampled = sampled
  end

  class Builder
    class ConfigABBuilder
      attr_accessor :config_ab

      def variant(weight, name, value = nil)
        @config_ab ||= ConfigAB.new
        @config_ab[name] = { weight: weight, value: value || name }
      end
    end

    def initialize(config)
      @config = config
    end

    def respond_to?(m)
      true
    end

    def method_missing(m, *args, &block)
      if block_given?
        ConfigABBuilder.new.tap do |builder|
          builder.instance_eval(&block)
          @config[m.to_sym] = builder.config_ab
        end
      else
        @config[m.to_sym] = args[0]
      end
    end
  end

  def respond_to?(m)
    self.keys.include?(m) || super
  end

  def method_missing(m, *args, &block)
    value = self[m]

    if args.size > 0 && value.kind_of?(Hash)
      value[*(args.map { |a| a.to_sym })]
    else
      if value.kind_of?(Hash) && value.keys.sort == [:value, :variant].sort
        value[:value]
      else
        value
      end
    end
  end
end
