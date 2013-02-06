require "zlib"

class ConfigHash < Hash
  class ConfigAB < Hash
    def value_for_seed(seed)
      weight_sum = self.keys.reduce(:+)
      r = Random.new(seed).rand

      self.each do |weight, value|
        return value if r <= (weight.to_f / weight_sum.to_f)
      end

      self[self.keys.last]
    end
  end

  def initialize(sampled = false)
    @sampled = sampled
  end

  def to_sample_config(seed)
    raise "Trying to sample already sampled config hash" if @sampled

    ConfigHash.new(true).tap do |sample|
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

  def method_missing(m, *args, &block)
    if m =~ /=$/
      self[m.to_s[0..-2].to_sym] = args[0]
    else
      if args[0] == :ab
        self[m.to_sym] = ConfigAB.new.merge(args[1])
      else
        self[m]
      end
    end
  end
end
