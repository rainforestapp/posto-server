require "zlib"

class SampleableConfig < Hash
  def self.define(&block)
    SampleableConfig.new.tap do |config|
      Builder.new(config).instance_eval(&block)
    end
  end

  def for_app(app, &block)
    if @app_name
      raise "app name changed to #{app.name}" unless @app_name == app.name

      if block
        return block.call(self)
      else
        return self
      end
    else
      sample = SampleableConfig.new(@seed, app.name)

      self.each do |k, v|
        if v.kind_of?(Hash) && v[app.name]
          sample[k] = v[app.name]
        else
          sample[k] = v
        end
      end

      if block
        return block.call(sample)
      else
        return sample
      end
    end
  end

  def to_sampled_config(seed)
    raise "Trying to sample already sampled config hash" if @seed && @seed != seed

    SampleableConfig.new(seed, @app_name).tap do |sample|
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

  def initialize(seed = nil, app_name = nil)
    @seed = seed
    @app_name = app_name
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

    def app(name, &block)
      raise "app requires block" unless block_given?
      @current_app = name
      self.instance_eval(&block)
      @current_app = nil
    end

    def method_missing(m, *args, &block)
      if block_given?
        ConfigABBuilder.new.tap do |builder|
          builder.instance_eval(&block)
          if @current_app
            data = @config[m.to_sym] || {}
            data[@current_app] = builder.config_ab
            @config[m.to_sym] = data
          else
            @config[m.to_sym] = builder.config_ab
          end
        end
      else
        if @current_app
          data = @config[m.to_sym] || {}
          data[@current_app] = args[0]
          @config[m.to_sym] = data
        else
          @config[m.to_sym] = args[0]
        end
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
